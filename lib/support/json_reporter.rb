require 'json'
require 'rspec/core/formatters/base_formatter'

class JsonReporter < RSpec::Core::Formatters::BaseFormatter
  RSpec::Core::Formatters.register self, :start, :example_started, :example_passed, 
                                   :example_failed, :example_pending, :stop

  def initialize(output)
    super
    @results = {
      summary: {},
      examples: [],
      metadata: {}
    }
    @start_time = nil
    @current_example_start = nil
  end

  def start(notification)
    @start_time = Time.now
    @results[:metadata] = {
      test_framework: 'RSpec',
      selenium_version: Selenium::WebDriver::VERSION,
      ruby_version: RUBY_VERSION,
      platform: RUBY_PLATFORM,
      started_at: @start_time.iso8601,
      browser: ENV['BROWSER'] || 'chrome',
      environment: ENV['ENV'] || 'test',
      headless: ENV['HEADLESS'] || 'false'
    }
  end

  def example_started(notification)
    @current_example_start = Time.now
  end

  def example_passed(notification)
    record_example(notification, 'passed')
  end

  def example_failed(notification)
    record_example(notification, 'failed', {
      exception_class: notification.exception.class.name,
      exception_message: notification.exception.message,
      backtrace: notification.exception.backtrace&.first(10)
    })
  end

  def example_pending(notification)
    record_example(notification, 'pending', {
      pending_message: notification.example.execution_result.pending_message
    })
  end

  def stop(notification)
    end_time = Time.now
    duration = end_time - @start_time

    @results[:summary] = {
      total: @results[:examples].count,
      passed: @results[:examples].count { |ex| ex[:status] == 'passed' },
      failed: @results[:examples].count { |ex| ex[:status] == 'failed' },
      pending: @results[:examples].count { |ex| ex[:status] == 'pending' },
      duration: duration,
      started_at: @start_time.iso8601,
      finished_at: end_time.iso8601,
      success_rate: calculate_success_rate
    }

    write_json_report
    write_summary_report
  end

  private

  def record_example(notification, status, additional_data = {})
    duration = Time.now - @current_example_start
    
    example_data = {
      id: notification.example.id,
      description: notification.example.description,
      full_description: notification.example.full_description,
      status: status,
      duration: duration,
      location: notification.example.location,
      tags: notification.example.metadata[:tags] || [],
      started_at: @current_example_start.iso8601,
      finished_at: Time.now.iso8601
    }.merge(additional_data)

    @results[:examples] << example_data
  end

  def calculate_success_rate
    return 0 if @results[:examples].empty?
    passed = @results[:examples].count { |ex| ex[:status] == 'passed' }
    (passed.to_f / @results[:examples].count * 100).round(2)
  end

  def write_json_report
    File.open('reports/test_results.json', 'w') do |file|
      file.write(JSON.pretty_generate(@results))
    end
    puts "\n📊 JSON Report generated: reports/test_results.json"
  end

  def write_summary_report
    summary_html = generate_summary_dashboard
    File.open('reports/dashboard.html', 'w') do |file|
      file.write(summary_html)
    end
    puts "\n📈 Dashboard generated: reports/dashboard.html"
  end

  def generate_summary_dashboard
    <<~HTML
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Test Dashboard - Selenium Ruby</title>
          <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
          <style>
              body {
                  font-family: 'Arial', sans-serif;
                  margin: 0;
                  padding: 20px;
                  background: linear-gradient(135deg, #74b9ff, #0984e3);
                  min-height: 100vh;
              }
              
              .dashboard {
                  max-width: 1200px;
                  margin: 0 auto;
                  background: white;
                  border-radius: 20px;
                  box-shadow: 0 20px 40px rgba(0,0,0,0.1);
                  overflow: hidden;
              }
              
              .header {
                  background: linear-gradient(135deg, #2d3436, #636e72);
                  color: white;
                  padding: 30px;
                  text-align: center;
              }
              
              .header h1 {
                  margin: 0;
                  font-size: 2.5rem;
                  font-weight: 300;
              }
              
              .metrics {
                  display: grid;
                  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                  gap: 20px;
                  padding: 30px;
                  background: #f8f9fa;
              }
              
              .metric {
                  background: white;
                  padding: 25px;
                  border-radius: 15px;
                  text-align: center;
                  box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                  transition: transform 0.3s ease;
              }
              
              .metric:hover {
                  transform: translateY(-5px);
              }
              
              .metric-value {
                  font-size: 2.5rem;
                  font-weight: bold;
                  margin-bottom: 10px;
              }
              
              .metric-label {
                  color: #666;
                  font-size: 0.9rem;
                  text-transform: uppercase;
                  letter-spacing: 1px;
              }
              
              .success { color: #00b894; }
              .danger { color: #e17055; }
              .warning { color: #fdcb6e; }
              .info { color: #74b9ff; }
              
              .charts {
                  display: grid;
                  grid-template-columns: 1fr 1fr;
                  gap: 30px;
                  padding: 30px;
              }
              
              .chart-container {
                  background: white;
                  padding: 25px;
                  border-radius: 15px;
                  box-shadow: 0 5px 15px rgba(0,0,0,0.08);
              }
              
              .chart-title {
                  text-align: center;
                  margin-bottom: 20px;
                  color: #2d3436;
                  font-size: 1.2rem;
                  font-weight: 600;
              }
              
              .environment-info {
                  background: #f1f2f6;
                  padding: 20px;
                  margin: 20px;
                  border-radius: 10px;
                  border-left: 5px solid #74b9ff;
              }
              
              .environment-info h3 {
                  margin-top: 0;
                  color: #2d3436;
              }
              
              .env-grid {
                  display: grid;
                  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                  gap: 15px;
                  margin-top: 15px;
              }
              
              .env-item {
                  background: white;
                  padding: 10px 15px;
                  border-radius: 8px;
                  font-size: 0.9rem;
              }
              
              .env-label {
                  font-weight: bold;
                  color: #636e72;
              }
              
              .footer {
                  background: #2d3436;
                  color: white;
                  padding: 20px;
                  text-align: center;
              }
              
              .timestamp {
                  background: #ddd6fe;
                  color: #5b21b6;
                  padding: 10px 20px;
                  border-radius: 25px;
                  display: inline-block;
                  margin-top: 10px;
                  font-weight: 500;
              }
              
              @media (max-width: 768px) {
                  .charts {
                      grid-template-columns: 1fr;
                  }
                  .metrics {
                      grid-template-columns: repeat(2, 1fr);
                  }
              }
          </style>
      </head>
      <body>
          <div class="dashboard">
              <div class="header">
                  <h1>🎯 Test Execution Dashboard</h1>
                  <div class="timestamp">
                      Last Updated: #{Time.now.strftime('%B %d, %Y at %I:%M %p')}
                  </div>
              </div>
              
              <div class="metrics">
                  <div class="metric">
                      <div class="metric-value info">#{@results[:summary][:total]}</div>
                      <div class="metric-label">Total Tests</div>
                  </div>
                  <div class="metric">
                      <div class="metric-value success">#{@results[:summary][:passed]}</div>
                      <div class="metric-label">Passed</div>
                  </div>
                  <div class="metric">
                      <div class="metric-value danger">#{@results[:summary][:failed]}</div>
                      <div class="metric-label">Failed</div>
                  </div>
                  <div class="metric">
                      <div class="metric-value warning">#{@results[:summary][:pending]}</div>
                      <div class="metric-label">Pending</div>
                  </div>
                  <div class="metric">
                      <div class="metric-value info">#{@results[:summary][:success_rate]}%</div>
                      <div class="metric-label">Success Rate</div>
                  </div>
                  <div class="metric">
                      <div class="metric-value info">#{sprintf('%.2f', @results[:summary][:duration])}s</div>
                      <div class="metric-label">Duration</div>
                  </div>
              </div>
              
              <div class="charts">
                  <div class="chart-container">
                      <div class="chart-title">Test Results Overview</div>
                      <canvas id="resultsChart"></canvas>
                  </div>
                  <div class="chart-container">
                      <div class="chart-title">Performance Trend</div>
                      <canvas id="performanceChart"></canvas>
                  </div>
              </div>
              
              <div class="environment-info">
                  <h3>🔧 Environment Information</h3>
                  <div class="env-grid">
                      <div class="env-item">
                          <div class="env-label">Browser:</div>
                          #{@results[:metadata][:browser]}
                      </div>
                      <div class="env-item">
                          <div class="env-label">Environment:</div>
                          #{@results[:metadata][:environment]}
                      </div>
                      <div class="env-item">
                          <div class="env-label">Ruby Version:</div>
                          #{@results[:metadata][:ruby_version]}
                      </div>
                      <div class="env-item">
                          <div class="env-label">Selenium Version:</div>
                          #{@results[:metadata][:selenium_version]}
                      </div>
                      <div class="env-item">
                          <div class="env-label">Platform:</div>
                          #{@results[:metadata][:platform]}
                      </div>
                      <div class="env-item">
                          <div class="env-label">Headless Mode:</div>
                          #{@results[:metadata][:headless]}
                      </div>
                  </div>
              </div>
              
              <div class="footer">
                  <p>🚀 Automated Test Dashboard</p>
                  <p style="opacity: 0.8; margin-top: 5px;">Powered by Selenium Ruby Framework</p>
              </div>
          </div>
          
          <script>
              // Results Overview Chart
              const resultsCtx = document.getElementById('resultsChart').getContext('2d');
              new Chart(resultsCtx, {
                  type: 'doughnut',
                  data: {
                      labels: ['Passed', 'Failed', 'Pending'],
                      datasets: [{
                          data: [#{@results[:summary][:passed]}, #{@results[:summary][:failed]}, #{@results[:summary][:pending]}],
                          backgroundColor: ['#00b894', '#e17055', '#fdcb6e'],
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
              
              // Performance Chart
              const perfCtx = document.getElementById('performanceChart').getContext('2d');
              const testDurations = #{@results[:examples].map { |ex| ex[:duration].round(3) }};
              const testLabels = #{@results[:examples].map.with_index { |ex, i| "Test #{i + 1}" }};
              
              new Chart(perfCtx, {
                  type: 'line',
                  data: {
                      labels: testLabels,
                      datasets: [{
                          label: 'Duration (seconds)',
                          data: testDurations,
                          borderColor: '#74b9ff',
                          backgroundColor: 'rgba(116, 185, 255, 0.1)',
                          borderWidth: 3,
                          fill: true,
                          tension: 0.4
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
              
              // Auto-refresh every 30 seconds
              setTimeout(() => {
                  location.reload();
              }, 30000);
          </script>
      </body>
      </html>
    HTML
  end
end
