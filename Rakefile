require 'rspec/core/rake_task'

# Default task
task default: :spec

# RSpec task with modern reporting
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = '--format documentation --color'
end

# Enhanced test tasks with comprehensive reporting
namespace :test do
  desc 'Run tests with all reports (HTML, JSON, Allure)'
  task :full_reports do
    system('./run_tests.sh --reports all')
  end

  desc 'Run tests in Chrome with full reporting'
  task :chrome do
    ENV['BROWSER'] = 'chrome'
    system('./run_tests.sh --reports all')
  end

  desc 'Run tests in Firefox with full reporting'
  task :firefox do
    ENV['BROWSER'] = 'firefox'
    system('./run_tests.sh --reports all')
  end

  desc 'Run tests in headless mode with full reporting'
  task :headless do
    ENV['HEADLESS'] = 'true'
    system('./run_tests.sh --reports all')
  end

  desc 'Run smoke tests with full reporting'
  task :smoke do
    system('./run_tests.sh --tag smoke --reports all')
  end

  desc 'Run regression tests with full reporting'
  task :regression do
    system('./run_tests.sh --tag regression --reports all')
  end

  desc 'Run tests in parallel with full reporting'
  task :parallel do
    system('./run_tests.sh --parallel --reports all')
  end
end

# Environment tasks with reporting
namespace :env do
  desc 'Run tests in staging environment with full reporting'
  task :staging do
    ENV['ENV'] = 'staging'
    system('./run_tests.sh --reports all')
  end

  desc 'Run tests in production environment with full reporting'
  task :production do
    ENV['ENV'] = 'production'
    system('./run_tests.sh --reports all')
  end
end

# Report-specific tasks
namespace :reports do
  desc 'Generate only HTML reports'
  task :html do
    system('./run_tests.sh --reports html')
  end

  desc 'Generate only JSON reports'
  task :json do
    system('./run_tests.sh --reports json')
  end

  desc 'Generate only Allure reports'
  task :allure do
    system('./run_tests.sh --reports allure')
  end

  desc 'Generate Allure report from existing results'
  task :allure_generate do
    if system('which allure > /dev/null 2>&1')
      system('allure generate reports/allure-results --clean -o reports/allure-report')
      puts "✅ Allure report generated: reports/allure-report/index.html"
      puts "🌐 Open with: open reports/allure-report/index.html"
    else
      puts "❌ Allure not installed. Install with: npm install -g allure-commandline"
    end
  end

  desc 'Serve Allure report'
  task :allure_serve do
    if system('which allure > /dev/null 2>&1')
      system('allure serve reports/allure-results')
    else
      puts "❌ Allure not installed. Install with: npm install -g allure-commandline"
    end
  end

  desc 'Open all generated reports'
  task :open do
    reports = [
      'reports/test_report.html',
      'reports/dashboard.html',
      'reports/allure-report/index.html'
    ]
    
    reports.each do |report|
      if File.exist?(report)
        system("open #{report}")
        puts "📄 Opening: #{report}"
      end
    end
  end

  desc 'Clean all reports'
  task :clean do
    system('rm -rf reports/*.html reports/*.json reports/screenshots/* reports/allure-results/* reports/allure-report/*')
    puts "🧹 All reports cleaned!"
  end
end

# Utility tasks
namespace :utils do
  desc 'Install dependencies'
  task :setup do
    puts "📦 Installing Ruby dependencies..."
    system('bundle install')
    puts "✅ Ruby dependencies installed!"
    
    puts "\n📦 Checking for Allure installation..."
    if system('which allure > /dev/null 2>&1')
      puts "✅ Allure is already installed!"
    else
      puts "⚠️  Allure not found. Install with: npm install -g allure-commandline"
    end
    
    puts "\n📁 Creating report directories..."
    system('mkdir -p reports/{screenshots,allure-results,allure-report}')
    puts "✅ Setup complete!"
  end

  desc 'Check code style'
  task :rubocop do
    system('bundle exec rubocop')
  end

  desc 'Auto-correct code style'
  task :rubocop_fix do
    system('bundle exec rubocop --auto-correct')
  end

  desc 'Show system information'
  task :info do
    puts "🔍 System Information:"
    puts "   Ruby Version: #{RUBY_VERSION}"
    puts "   Platform: #{RUBY_PLATFORM}"
    puts "   Bundler Version: #{`bundle --version`.strip}"
    
    browsers = %w[chrome firefox safari]
    browsers.each do |browser|
      case browser
      when 'chrome'
        if system('which google-chrome > /dev/null 2>&1') || system('which chromium-browser > /dev/null 2>&1') || system('ls /Applications/Google\ Chrome.app > /dev/null 2>&1')
          puts "   ✅ Chrome: Available"
        else
          puts "   ❌ Chrome: Not found"
        end
      when 'firefox'
        if system('which firefox > /dev/null 2>&1') || system('ls /Applications/Firefox.app > /dev/null 2>&1')
          puts "   ✅ Firefox: Available"
        else
          puts "   ❌ Firefox: Not found"
        end
      when 'safari'
        if system('ls /Applications/Safari.app > /dev/null 2>&1')
          puts "   ✅ Safari: Available"
        else
          puts "   ❌ Safari: Not found"
        end
      end
    end
    
    if system('which allure > /dev/null 2>&1')
      allure_version = `allure --version`.strip
      puts "   ✅ Allure: #{allure_version}"
    else
      puts "   ❌ Allure: Not installed"
    end
  end
end

desc 'Show comprehensive help with examples'
task :help do
  puts <<~HELP
    🎯 Selenium Ruby Automation Framework - Task Reference
    
    📋 Basic Tasks:
      rake spec                    # Run all tests (basic)
      rake test:full_reports       # Run all tests with comprehensive reports
      rake test:chrome             # Run tests in Chrome
      rake test:firefox            # Run tests in Firefox
      rake test:headless           # Run tests in headless mode
      rake test:smoke              # Run smoke tests only
      rake test:regression         # Run regression tests only
      rake test:parallel           # Run tests in parallel
    
    🌐 Environment Tasks:
      rake env:staging             # Run tests in staging environment
      rake env:production          # Run tests in production environment
    
    📊 Report Tasks:
      rake reports:html            # Generate HTML reports only
      rake reports:json            # Generate JSON reports only
      rake reports:allure          # Generate Allure reports only
      rake reports:allure_generate # Generate Allure report from results
      rake reports:allure_serve    # Serve Allure report in browser
      rake reports:open            # Open all generated reports
      rake reports:clean           # Clean all reports
    
    🔧 Utility Tasks:
      rake utils:setup             # Install dependencies and setup
      rake utils:info              # Show system information
      rake utils:rubocop           # Check code style
      rake utils:rubocop_fix       # Auto-correct code style
    
    💡 Advanced Examples:
      # Run specific combinations
      BROWSER=firefox HEADLESS=true rake test:smoke
      ENV=staging rake test:regression
      
      # Using the advanced runner script
      ./run_tests.sh --browser firefox --headless --tag smoke --reports allure
      ./run_tests.sh --parallel --reports all
      
    📁 Generated Reports:
      • HTML Report: reports/test_report.html (Modern, interactive)
      • Dashboard: reports/dashboard.html (Real-time metrics)
      • JSON Data: reports/test_results.json (For CI/CD integration)
      • Allure Report: reports/allure-report/index.html (Enterprise-grade)
      • Screenshots: reports/screenshots/ (Failure evidence)
    
    🚀 Quick Start:
      1. rake utils:setup          # First-time setup
      2. rake test:full_reports    # Run tests with all reports
      3. rake reports:open         # View generated reports
  HELP
end
