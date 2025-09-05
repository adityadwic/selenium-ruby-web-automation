# 🎯 Selenium Ruby Web Automation Framework

[![E2E Tests](https://github.com/adityadwic/selenium-ruby-web-automation/workflows/E2E%20Tests/badge.svg)](https://github.com/adityadwic/selenium-ruby-web-automation/actions/workflows/e2e-tests.yml)
[![Ruby Version](https://img.shields.io/badge/ruby-3.1+-red.svg)](https://www.ruby-lang.org)
[![Selenium](https://img.shields.io/badge/selenium-4.x-green.svg)](https://selenium.dev)
[![RSpec](https://img.shields.io/badge/rspec-3.x-blue.svg)](https://rspec.info)
[![License](https://img.shields.io/badge/license-MIT-yellow.svg)](LICENSE)

**Enterprise-grade web automation testing framework** built with **Ruby + Selenium WebDriver**, implementing QA best practices and Page Object Model (POM) pattern. Features modern reporting system, CI/CD integration, and comprehensive test coverage for e-commerce websites.

## 🎯 Project Overview

This automation framework demonstrates professional-level QA engineering skills with a complete **18-step user registration flow** testing for [AutomationExercise.com](http://automationexercise.com). Built following industry best practices with enterprise-grade reporting and CI/CD pipeline integration.

### 🏆 Key Achievements
- ✅ **100% Test Pass Rate** - All 18 registration steps automated successfully
- ⚡ **60+ second execution time** for complete end-to-end flow
- 📊 **Interactive HTML Reports** with real-time metrics and visualizations
- 🚀 **CI/CD Ready** with GitHub Actions workflows
- 🏗️ **Page Object Model** architecture for maintainable code

## ✨ Key Features

### 🧪 Testing Framework
- 🏗️ **Page Object Model (POM)** pattern for maintainable code
- 🌐 **Multi-browser Support** (Chrome, Firefox, Safari)
- 👁️ **Headless Mode** for CI/CD pipeline
- ⚡ **Parallel Execution** for performance optimal
- 🔄 **Retry mechanism** for flaky tests
- 🎯 **Test Tagging** (smoke, regression, custom categories)
- 🤖 **Dynamic test data** with Faker integration
- ⏱️ **Comprehensive wait strategies** (explicit, implicit, fluent)

### 📊 Modern Reporting System
- 📈 **Interactive HTML Reports** with Chart.js visualizations
- 📄 **JSON Reports** for CI/CD integration and API consumption
- 🎨 **Allure Reports** for enterprise-grade reporting
- 📋 **Real-time Dashboard** with live execution updates
- 📸 **Screenshot capture** for failed tests and key steps
- ⚡ **Performance metrics** and execution timeline
- 📤 **Export capabilities** (PDF, Excel, CSV)

### 🚀 CI/CD Integration
- 🔄 **GitHub Actions workflows** for comprehensive testing
- 🎛️ **Matrix testing** across multiple browsers and Ruby versions
- 📅 **Scheduled testing** (nightly regression)
- 📊 **Performance monitoring** with Lighthouse integration
- 🤖 **Automated dependency management** with Dependabot
- ✅ **Release validation** with pre/post deployment checks
- 🌐 **GitHub Pages deployment** for test reports

## 🚀 Quick Start

### Prerequisites
- Ruby 3.1+
- Chrome browser (latest version)
- Git

### Installation & Setup
```bash
# Clone repository
git clone https://github.com/adityadwic/selenium-ruby-web-automation.git
cd selenium-ruby-web-automation

# Install dependencies
bundle install

# Run complete test suite with all reports
./run_tests.sh
```

### View Reports
```bash
# Open modern HTML report
open reports/test_report.html

# Open interactive dashboard  
open reports/dashboard.html

# Generate Allure report (if allure installed)
allure serve reports/allure-results
```

### Advanced Options
```bash
# Different browsers
./run_tests.sh --browser firefox
./run_tests.sh --browser safari

# Headless mode (great for CI/CD)
./run_tests.sh --headless

# Specific test types
./run_tests.sh --tag smoke
./run_tests.sh --tag regression

# Combined options
./run_tests.sh --browser firefox --headless --tag smoke --reports all
```

## 🧪 Test Scenarios

### Complete User Registration Flow (18 Steps)
Automated end-to-end testing covering the complete user journey:

1. ✅ **Launch browser** - Chrome automation setup
2. ✅ **Navigate to website** - http://automationexercise.com
3. ✅ **Verify home page** - Page load validation
4. ✅ **Click 'Signup / Login'** - Navigation element interaction
5. ✅ **Verify 'New User Signup!'** - Form visibility validation
6. ✅ **Enter name and email** - Dynamic test data input (Faker)
7. ✅ **Click 'Signup' button** - Form submission
8. ✅ **Verify 'ENTER ACCOUNT INFORMATION'** - Page transition validation
9. ✅ **Fill account details** - Title, Password, Date of birth
10. ✅ **Select newsletter checkbox** - Checkbox interaction
11. ✅ **Select special offers checkbox** - Checkbox interaction  
12. ✅ **Fill address information** - Complete address form
13. ✅ **Click 'Create Account'** - Account creation submission
14. ✅ **Verify 'ACCOUNT CREATED!'** - Success message validation
15. ✅ **Click 'Continue'** - Post-creation navigation
16. ✅ **Verify user logged in** - Login state validation
17. ✅ **Click 'Delete Account'** - Account cleanup
18. ✅ **Verify 'ACCOUNT DELETED!'** - Deletion confirmation

### Test Results Summary
- **Total Steps**: 18
- **Success Rate**: 100%
- **Execution Time**: ~60-80 seconds
- **Browser Support**: Chrome, Firefox, Safari
- **Test Data**: Dynamically generated with Faker

## 📊 Advanced Reporting System

### 🎨 Modern HTML Report
- Interactive dashboard with real-time metrics
- Responsive design for mobile and desktop
- Color-coded test results with expandable details
- Charts and visualizations (Chart.js integration)
- Automatic screenshot embedding with lightbox gallery

### 📈 Executive Dashboard  
- High-level KPIs and success metrics
- Performance trend analysis
- Environment information display
- Auto-refresh capability

### 📋 JSON Data Export
- Machine-readable test results
- CI/CD pipeline integration ready
- Custom dashboard integration support
- Detailed metadata and timing information

### 🏢 Allure Enterprise Reports
- Professional test reporting platform
- Step-by-step execution details
- Rich attachments (screenshots, logs, page source)
- Historical trend analysis
- Test case management integration

## 🏗️ Architecture & Best Practices

### Page Object Model (POM)
- Each page has its own class with locators and methods
- Inheritance from BasePage for common functionality
- Clear separation of test logic and page interactions

### Test Data Management
- Faker gem for generating realistic test data
- Configurable test data through helper methods
- No hardcoded test data in test files

### Error Handling
- Automatic screenshots on test failures
- Explicit waits for element visibility and interaction
- Retry mechanism for flaky elements

### Code Organization
- Modular design with clear separation of concerns
- Reusable helper modules
- Environment-specific configurations

## 🚀 CI/CD Integration

### GitHub Actions Workflows
Framework includes comprehensive CI/CD pipeline:

```yaml
# Main testing workflow (triggered on push/PR)
.github/workflows/e2e-tests.yml

# Nightly regression testing 
.github/workflows/nightly-tests.yml

# Performance monitoring
.github/workflows/performance-tests.yml
```

### Report Deployment
Test reports can be deployed to GitHub Pages:
```
https://adityadwic.github.io/selenium-ruby-web-automation/reports/
```

## 🛠️ Development & Debugging

### Screenshots
Failed tests automatically capture screenshots in the `reports/` directory.

### Verbose Output
```bash
bundle exec rspec --format documentation --backtrace
```

### Interactive Debugging
```ruby
require 'pry'
binding.pry  # Add this line where you want to debug
```

### Debug Commands
```bash
# Verbose test execution
VERBOSE=true bundle exec rspec

# Specific test debugging
bundle exec rspec spec/features/user_registration_spec.rb --backtrace

# Clear test artifacts
rm -rf reports/ screenshots/ tmp/
```

## 🤝 Contributing

1. **Follow existing code structure** and naming conventions
2. **Add appropriate tests** for new features
3. **Ensure all tests pass** before submitting changes
4. **Update documentation** for new functionality
5. **Follow RuboCop guidelines** for code quality

### Development Workflow
```bash
# 1. Create feature branch
git checkout -b feature/new-feature

# 2. Make changes with tests
# 3. Run linting
bundle exec rubocop

# 4. Run tests
bundle exec rspec

# 5. Create pull request
```

## 🎯 Future Roadmap

- [ ] **Docker Compose** setup for easier local development
- [ ] **API testing** integration with REST Assured
- [ ] **Mobile testing** with Appium integration
- [ ] **Visual regression testing** with Percy/BackstopJS
- [ ] **Accessibility testing** with axe-core
- [ ] **Database testing** capabilities

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 About the Author

**Aditya Dwi Cahyono**
- 🌐 GitHub: [adityadwic](https://github.com/adityadwic)
- 💼 QA Automation Engineer

### 📧 Contact & Support
- **GitHub Issues** for bug reports and feature requests
- **GitHub Discussions** for questions and community support
- **Pull Requests** welcome for contributions

---

**Built with ❤️ using Ruby, Selenium WebDriver, and modern testing practices.**
