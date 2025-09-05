require 'rspec/core/formatters/base_formatter'
require 'erb'
require 'time'

class ModernHtmlFormatter < RSpec::Core::Formatters::BaseFormatter
  RSpec::Core::Formatters.register self, :start, :example_started, :example_passed, 
                                   :example_failed, :example_pending, :stop

  def initialize(output)
    super
    @examples = []
    @start_time = nil
    @end_time = nil
  end

  def start(notification)
    @start_time = Time.now
    @example_count = notification.count
  end

  def example_started(notification)
    @current_example_start = Time.now
  end

  def example_passed(notification)
    duration = Time.now - @current_example_start
    @examples << {
      description: notification.example.full_description,
      status: 'passed',
      duration: duration,
      location: notification.example.location,
      metadata: notification.example.metadata
    }
  end

  def example_failed(notification)
    duration = Time.now - @current_example_start
    @examples << {
      description: notification.example.full_description,
      status: 'failed',
      duration: duration,
      location: notification.example.location,
      metadata: notification.example.metadata,
      exception: notification.exception,
      formatted_backtrace: notification.formatted_backtrace
    }
  end

  def example_pending(notification)
    duration = Time.now - @current_example_start
    @examples << {
      description: notification.example.full_description,
      status: 'pending',
      duration: duration,
      location: notification.example.location,
      metadata: notification.example.metadata,
      pending_message: notification.example.execution_result.pending_message
    }
  end

  def stop(notification)
    @end_time = Time.now
    @duration = @end_time - @start_time
    
    generate_html_report
  end

  private

  def generate_html_report
    template = ERB.new(html_template)
    html_content = template.result(binding)
    
    File.open('reports/test_report.html', 'w') do |file|
      file.write(html_content)
    end
    
    puts "\n🎯 Modern HTML Report generated: reports/test_report.html"
  end

  def passed_count
    @examples.count { |ex| ex[:status] == 'passed' }
  end

  def failed_count
    @examples.count { |ex| ex[:status] == 'failed' }
  end

  def pending_count
    @examples.count { |ex| ex[:status] == 'pending' }
  end

  def success_rate
    return 0 if @examples.empty?
    ((passed_count.to_f / @examples.count) * 100).round(1)
  end

  def html_template
    <<~HTML
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Selenium Ruby Test Report</title>
          <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
          <style>
              * {
                  margin: 0;
                  padding: 0;
                  box-sizing: border-box;
              }
              
              body {
                  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                  min-height: 100vh;
                  padding: 20px;
              }
              
              .container {
                  max-width: 1200px;
                  margin: 0 auto;
                  background: white;
                  border-radius: 20px;
                  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
                  overflow: hidden;
              }
              
              .header {
                  background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
                  color: white;
                  padding: 40px;
                  text-align: center;
              }
              
              .header h1 {
                  font-size: 2.5em;
                  margin-bottom: 10px;
                  font-weight: 300;
              }
              
              .header .subtitle {
                  font-size: 1.1em;
                  opacity: 0.8;
              }
              
              .stats-grid {
                  display: grid;
                  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                  gap: 20px;
                  padding: 40px;
                  background: #f8f9fa;
              }
              
              .stat-card {
                  background: white;
                  padding: 30px;
                  border-radius: 15px;
                  text-align: center;
                  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
                  transition: transform 0.3s ease;
              }
              
              .stat-card:hover {
                  transform: translateY(-2px);
                  box-shadow: 0 12px 35px rgba(0, 0, 0, 0.08);
              }
              
              .stat-number {
                  font-size: 2.5em;
                  font-weight: bold;
                  margin-bottom: 10px;
              }
              
              .stat-label {
                  color: #666;
                  font-size: 0.9em;
                  text-transform: uppercase;
                  letter-spacing: 1px;
              }
              
              .passed { color: #27ae60; }
              .failed { color: #e74c3c; }
              .pending { color: #f39c12; }
              .total { color: #3498db; }
              
              .chart-container {
                  padding: 40px;
                  display: grid;
                  grid-template-columns: 1fr 1fr;
                  gap: 40px;
                  align-items: center;
              }
              
              .chart-box {
                  background: white;
                  padding: 20px;
                  border-radius: 15px;
                  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
              }
              
              .test-results {
                  padding: 40px;
              }
              
              .test-item {
                  background: white;
                  margin-bottom: 15px;
                  border-radius: 10px;
                  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
                  overflow: hidden;
                  transition: all 0.3s ease;
              }
              
              .test-item:hover {
                  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
                  transform: translateY(-1px);
              }
              
              .test-header {
                  padding: 20px;
                  display: flex;
                  justify-content: space-between;
                  align-items: center;
                  cursor: pointer;
              }
              
              .test-title {
                  font-weight: 600;
                  flex: 1;
              }
              
              .test-status {
                  padding: 8px 16px;
                  border-radius: 20px;
                  color: white;
                  font-size: 0.8em;
                  font-weight: bold;
                  text-transform: uppercase;
              }
              
              .status-passed { background: #27ae60; }
              .status-failed { background: #e74c3c; }
              .status-pending { background: #f39c12; }
              
              .test-duration {
                  color: #666;
                  font-size: 0.9em;
                  margin-left: 15px;
              }
              
              .test-details {
                  display: none;
                  padding: 20px;
                  background: #f8f9fa;
                  border-top: 1px solid #eee;
              }
              
              .test-details.show {
                  display: block;
              }
              
              .error-message {
                  background: #fff5f5;
                  border-left: 4px solid #e74c3c;
                  padding: 15px;
                  margin-top: 10px;
                  border-radius: 5px;
                  font-family: monospace;
                  font-size: 0.9em;
                  white-space: pre-wrap;
              }
              
              .test-location {
                  color: #666;
                  font-size: 0.8em;
                  margin-top: 5px;
              }
              
              .footer {
                  background: #2c3e50;
                  color: white;
                  padding: 30px 40px;
                  text-align: center;
              }
              
              @media (max-width: 768px) {
                  .chart-container {
                      grid-template-columns: 1fr;
                  }
                  
                  .stats-grid {
                      grid-template-columns: repeat(2, 1fr);
                  }
              }
          </style>
      </head>
      <body>
          <div class="container">
              <div class="header">
                  <h1>🎯 Selenium Ruby Test Report</h1>
                  <div class="subtitle">Automation Exercise - User Registration Flow</div>
                  <div class="subtitle" style="margin-top: 10px;">
                      Generated on <%= @end_time.strftime('%B %d, %Y at %I:%M %p') %>
                  </div>
              </div>
              
              <div class="stats-grid">
                  <div class="stat-card">
                      <div class="stat-number total"><%= @examples.count %></div>
                      <div class="stat-label">Total Tests</div>
                  </div>
                  <div class="stat-card">
                      <div class="stat-number passed"><%= passed_count %></div>
                      <div class="stat-label">Passed</div>
                  </div>
                  <div class="stat-card">
                      <div class="stat-number failed"><%= failed_count %></div>
                      <div class="stat-label">Failed</div>
                  </div>
                  <div class="stat-card">
                      <div class="stat-number pending"><%= pending_count %></div>
                      <div class="stat-label">Pending</div>
                  </div>
                  <div class="stat-card">
                      <div class="stat-number total"><%= success_rate %>%</div>
                      <div class="stat-label">Success Rate</div>
                  </div>
                  <div class="stat-card">
                      <div class="stat-number total"><%= sprintf('%.2f', @duration) %>s</div>
                      <div class="stat-label">Duration</div>
                  </div>
              </div>
              
              <div class="chart-container">
                  <div class="chart-box">
                      <h3 style="text-align: center; margin-bottom: 20px; color: #2c3e50;">Test Results Distribution</h3>
                      <canvas id="pieChart" width="300" height="300"></canvas>
                  </div>
                  <div class="chart-box">
                      <h3 style="text-align: center; margin-bottom: 20px; color: #2c3e50;">Test Duration Analysis</h3>
                      <canvas id="barChart" width="300" height="300"></canvas>
                  </div>
              </div>
              
              <div class="test-results">
                  <h2 style="margin-bottom: 30px; color: #2c3e50;">📋 Detailed Test Results</h2>
                  
                  <% @examples.each_with_index do |example, index| %>
                  <div class="test-item">
                      <div class="test-header" onclick="toggleDetails(<%= index %>)">
                          <div class="test-title"><%= example[:description] %></div>
                          <div style="display: flex; align-items: center;">
                              <span class="test-status status-<%= example[:status] %>"><%= example[:status] %></span>
                              <span class="test-duration"><%= sprintf('%.3f', example[:duration]) %>s</span>
                          </div>
                      </div>
                      <div class="test-details" id="details-<%= index %>">
                          <div class="test-location">📍 <%= example[:location] %></div>
                          <% if example[:status] == 'failed' %>
                              <div class="error-message">
                                  <strong>❌ Error:</strong> <%= example[:exception].message %>
                                  
                                  <% if example[:formatted_backtrace] %>
                                  <details style="margin-top: 10px;">
                                      <summary style="cursor: pointer; font-weight: bold;">🔍 Stack Trace</summary>
                                      <pre style="margin-top: 10px; font-size: 0.8em;"><%= example[:formatted_backtrace].join("\\n") %></pre>
                                  </details>
                                  <% end %>
                              </div>
                          <% elsif example[:status] == 'pending' %>
                              <div style="background: #fff8e1; border-left: 4px solid #f39c12; padding: 15px; margin-top: 10px; border-radius: 5px;">
                                  <strong>⏳ Pending:</strong> <%= example[:pending_message] %>
                              </div>
                          <% else %>
                              <div style="background: #f0f9ff; border-left: 4px solid #27ae60; padding: 15px; margin-top: 10px; border-radius: 5px;">
                                  <strong>✅ Test passed successfully!</strong>
                              </div>
                          <% end %>
                      </div>
                  </div>
                  <% end %>
              </div>
              
              <div class="footer">
                  <p>🚀 Generated by Selenium Ruby Automation Framework</p>
                  <p style="margin-top: 5px; opacity: 0.8;">Built with ❤️ using Ruby, RSpec, and Selenium WebDriver</p>
              </div>
          </div>
          
          <script>
              // Toggle test details
              function toggleDetails(index) {
                  const details = document.getElementById('details-' + index);
                  details.classList.toggle('show');
              }
              
              // Pie Chart
              const pieCtx = document.getElementById('pieChart').getContext('2d');
              new Chart(pieCtx, {
                  type: 'doughnut',
                  data: {
                      labels: ['Passed', 'Failed', 'Pending'],
                      datasets: [{
                          data: [<%= passed_count %>, <%= failed_count %>, <%= pending_count %>],
                          backgroundColor: ['#27ae60', '#e74c3c', '#f39c12'],
                          borderWidth: 0
                      }]
                  },
                  options: {
                      responsive: true,
                      maintainAspectRatio: false,
                      plugins: {
                          legend: {
                              position: 'bottom',
                              labels: {
                                  padding: 20,
                                  usePointStyle: true
                              }
                          }
                      }
                  }
              });
              
              // Bar Chart for test durations
              const barCtx = document.getElementById('barChart').getContext('2d');
              new Chart(barCtx, {
                  type: 'bar',
                  data: {
                      labels: [<% @examples.each_with_index do |ex, i| %>'Test <%= i + 1 %>'<%= ',' unless i == @examples.length - 1 %><% end %>],
                      datasets: [{
                          label: 'Duration (seconds)',
                          data: [<% @examples.each_with_index do |ex, i| %><%= sprintf('%.3f', ex[:duration]) %><%= ',' unless i == @examples.length - 1 %><% end %>],
                          backgroundColor: [<% @examples.each_with_index do |ex, i| %>'<%= ex[:status] == 'passed' ? '#27ae60' : ex[:status] == 'failed' ? '#e74c3c' : '#f39c12' %>'<%= ',' unless i == @examples.length - 1 %><% end %>],
                          borderRadius: 5
                      }]
                  },
                  options: {
                      responsive: true,
                      maintainAspectRatio: false,
                      plugins: {
                          legend: {
                              display: false
                          }
                      },
                      scales: {
                          y: {
                              beginAtZero: true,
                              title: {
                                  display: true,
                                  text: 'Duration (seconds)'
                              }
                          },
                          x: {
                              title: {
                                  display: true,
                                  text: 'Test Cases'
                              }
                          }
                      }
                  }
              });
          </script>
      </body>
      </html>
    HTML
  end
end
