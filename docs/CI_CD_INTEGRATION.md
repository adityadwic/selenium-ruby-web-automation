# 🚀 CI/CD Integration Guide

Panduan lengkap untuk menjalankan automation testing dengan GitHub Actions.

## 📋 Table of Contents

- [Overview](#overview)
- [GitHub Actions Workflows](#github-actions-workflows)
- [Setup Requirements](#setup-requirements)
- [Environment Variables](#environment-variables)
- [Workflow Configuration](#workflow-configuration)
- [Report Management](#report-management)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

## 🎯 Overview

Framework automation ini sudah dilengkapi dengan comprehensive CI/CD pipeline menggunakan GitHub Actions. Pipeline ini mendukung:

- ✅ **Multi-browser Testing** (Chrome, Firefox, Safari)
- ✅ **Parallel Execution** untuk performa optimal
- ✅ **Scheduled Testing** (nightly regression)
- ✅ **Performance Monitoring** dengan Lighthouse
- ✅ **Multiple Report Formats** (HTML, JSON, Allure)
- ✅ **Automated Dependency Management**
- ✅ **Release Validation**

## 🔄 GitHub Actions Workflows

### 1. E2E Tests (`e2e-tests.yml`)

**Trigger:** Push ke main/develop, Pull Request
**Purpose:** Comprehensive testing dengan code quality checks

```yaml
# Runs on:
- push: [main, develop]
- pull_request: [main, develop]
- manual dispatch

# Features:
- RuboCop linting
- Matrix testing (Chrome, Firefox, Safari)
- Parallel execution
- Multi-format reporting
- Report deployment to GitHub Pages
```

**Key Commands:**
```bash
# Manual trigger
gh workflow run e2e-tests.yml

# With specific browser
gh workflow run e2e-tests.yml -f browser=chrome
```

### 2. Nightly Tests (`nightly-tests.yml`)

**Trigger:** Scheduled (01:00 UTC daily)
**Purpose:** Full regression testing dengan consolidated reporting

```yaml
# Schedule: 01:00 UTC daily
# Features:
- Full test suite execution
- All browser coverage
- Consolidated reporting
- Slack notifications (opsional)
```

### 3. Release Deploy (`release-deploy.yml`)

**Trigger:** Release creation
**Purpose:** Pre/post deployment validation

```yaml
# Runs on: release creation
# Features:
- Pre-deployment smoke tests
- Post-deployment validation
- Performance regression testing
- Rollback support
```

### 4. Performance Tests (`performance-tests.yml`)

**Trigger:** Manual, scheduled weekly
**Purpose:** Performance monitoring dan load testing

```yaml
# Features:
- Lighthouse audit
- Load testing simulation
- Performance regression detection
- Performance report generation
```

## ⚙️ Setup Requirements

### 1. GitHub Repository Setup

```bash
# 1. Push code to GitHub repository
git init
git remote add origin <your-repo-url>
git add .
git commit -m "Initial commit"
git push -u origin main

# 2. Enable GitHub Actions
# Go to repository Settings > Actions > General
# Select "Allow all actions and reusable workflows"
```

### 2. GitHub Pages Setup (untuk reports)

```bash
# 1. Go to repository Settings > Pages
# 2. Source: GitHub Actions
# 3. Reports akan tersedia di: https://<username>.github.io/<repo-name>
```

### 3. Secrets Configuration

Buat secrets di repository Settings > Secrets and variables > Actions:

```bash
# Required secrets:
SLACK_WEBHOOK_URL=https://hooks.slack.com/services/...  # Opsional
PERFORMANCE_THRESHOLD=90  # Lighthouse score threshold
```

## 🌍 Environment Variables

### GitHub Actions Variables

```yaml
# .github/workflows/*.yml
env:
  RUBY_VERSION: 3.1
  BUNDLER_VERSION: 2.4.0
  RAILS_ENV: test
  SELENIUM_BROWSER: chrome  # chrome, firefox, safari
  HEADLESS: true
  PARALLEL_TESTS: 4
  RETRY_COUNT: 2
  REPORT_FORMAT: html,json,allure
```

### Local Environment

```bash
# .env file (untuk local development)
SELENIUM_BROWSER=chrome
HEADLESS=false
BASE_URL=https://automationexercise.com
EXPLICIT_WAIT=10
IMPLICIT_WAIT=5
PAGE_LOAD_TIMEOUT=30
REPORT_PATH=./reports
SCREENSHOT_PATH=./reports/screenshots
LOG_LEVEL=INFO
```

## 📊 Workflow Configuration

### Matrix Testing Configuration

```yaml
# Multi-browser matrix
strategy:
  matrix:
    browser: [chrome, firefox, safari]
    ruby-version: [3.1, 3.2]
  fail-fast: false
  max-parallel: 3
```

### Conditional Execution

```yaml
# Browser-specific conditions
- name: Setup Chrome
  if: matrix.browser == 'chrome'
  uses: browser-actions/setup-chrome@latest

- name: Setup Firefox  
  if: matrix.browser == 'firefox'
  uses: browser-actions/setup-firefox@latest
```

### Artifact Management

```yaml
# Report artifacts
- name: Upload Test Reports
  uses: actions/upload-artifact@v4
  if: always()
  with:
    name: test-reports-${{ matrix.browser }}
    path: |
      reports/
      screenshots/
    retention-days: 30
```

## 📈 Report Management

### 1. HTML Reports

```bash
# Location: reports/test_results.html
# Features:
- Interactive charts
- Test execution timeline
- Screenshot gallery
- Responsive design
- Export capabilities
```

### 2. JSON Reports

```bash
# Location: reports/test_results.json
# Purpose: CI/CD integration, API consumption
# Format: Structured data untuk automation tools
```

### 3. Allure Reports

```bash
# Location: reports/allure/
# Features:
- Enterprise-grade reporting
- Historical trending
- Step-by-step execution
- Attachment support
```

### 4. GitHub Pages Deployment

Reports otomatis di-deploy ke GitHub Pages:

```bash
# URL Pattern:
https://<username>.github.io/<repo-name>/reports/

# Report Types:
/html/          # Interactive HTML reports
/json/          # JSON data
/allure/        # Allure reports
/performance/   # Lighthouse reports
```

## 🔧 Troubleshooting

### Common Issues

#### 1. Browser Setup Issues

```bash
# Chrome issues
Error: chrome not found
Solution: Update chrome-driver version in workflow

# Firefox issues  
Error: geckodriver not found
Solution: Use browser-actions/setup-firefox@latest

# Safari issues (macOS only)
Error: safaridriver not found
Solution: Enable Remote Automation in Safari settings
```

#### 2. Test Execution Issues

```bash
# Timeout issues
Error: Element not found within timeout
Solution: 
- Increase EXPLICIT_WAIT value
- Check element selectors
- Add proper wait strategies

# Flaky tests
Error: Intermittent failures
Solution:
- Implement retry mechanism
- Use better wait strategies
- Add element visibility checks
```

#### 3. Report Generation Issues

```bash
# Missing reports
Error: Reports not generated
Solution:
- Check REPORT_PATH permissions
- Verify report formatter configuration
- Check disk space

# Chart.js not loading
Error: Charts not displaying
Solution:
- Verify internet connection for CDN
- Use local Chart.js files
- Check CSP headers
```

### Debug Commands

```bash
# Local debugging
bundle exec rspec --format documentation --backtrace

# Verbose output
VERBOSE=true bundle exec rspec

# Debug specific test
bundle exec rspec spec/features/user_registration_spec.rb --backtrace

# Check browser versions
google-chrome --version
firefox --version
/usr/bin/safaridriver --version
```

## 🎯 Best Practices

### 1. Workflow Organization

```yaml
# Use descriptive job names
jobs:
  code-quality:
    name: "Code Quality & Linting"
  
  cross-browser-tests:
    name: "Cross-Browser Tests (${{ matrix.browser }})"
  
  deploy-reports:
    name: "Deploy Test Reports"
```

### 2. Efficient Resource Usage

```bash
# Parallel execution
PARALLEL_TESTS=4

# Smart caching
- uses: actions/cache@v3
  with:
    path: vendor/bundle
    key: gems-${{ hashFiles('Gemfile.lock') }}

# Conditional steps
- name: Run expensive tests
  if: github.event_name == 'schedule'
```

### 3. Security Considerations

```bash
# Use secrets for sensitive data
env:
  API_KEY: ${{ secrets.API_KEY }}

# Limit permissions
permissions:
  contents: read
  pages: write
  id-token: write

# Validate inputs
- name: Validate inputs
  run: |
    if [[ ! "${{ inputs.browser }}" =~ ^(chrome|firefox|safari)$ ]]; then
      echo "Invalid browser specified"
      exit 1
    fi
```

### 4. Monitoring & Notifications

```yaml
# Slack notifications
- name: Notify Slack
  if: failure()
  uses: 8398a7/action-slack@v3
  with:
    status: failure
    webhook_url: ${{ secrets.SLACK_WEBHOOK_URL }}

# Email notifications (GitHub settings)
# Repository Settings > Notifications > Actions
```

### 5. Performance Optimization

```bash
# Use specific Ruby version
ruby-version: '3.1.4'  # Instead of '3.1'

# Optimize bundle install
run: |
  bundle config set --local deployment true
  bundle config set --local without development
  bundle install --jobs 4 --retry 3

# Parallel test execution
run: bundle exec parallel_rspec spec/
```

## 📚 Advanced Configuration

### Custom Workflow Triggers

```yaml
# Multiple triggers
on:
  push:
    branches: [main, develop]
    paths: ['spec/**', 'lib/**']
  pull_request:
    types: [opened, synchronize, reopened]
  schedule:
    - cron: '0 1 * * *'  # Daily at 1 AM UTC
  workflow_dispatch:
    inputs:
      browser:
        description: 'Browser to test'
        required: true
        default: 'chrome'
        type: choice
        options: [chrome, firefox, safari]
```

### Environment-Specific Configuration

```yaml
# Different configs per environment
- name: Setup Test Environment
  if: github.ref == 'refs/heads/main'
  env:
    BASE_URL: https://automationexercise.com
    
- name: Setup Staging Environment  
  if: github.ref == 'refs/heads/develop'
  env:
    BASE_URL: https://staging.automationexercise.com
```

## 🎉 Conclusion

Dengan konfigurasi CI/CD ini, automation testing framework sudah siap untuk:

1. ✅ **Continuous Integration** dengan GitHub Actions
2. ✅ **Multi-browser testing** otomatis
3. ✅ **Comprehensive reporting** dengan multiple formats
4. ✅ **Performance monitoring** berkelanjutan
5. ✅ **Automated dependency management**
6. ✅ **Release validation** otomatis

Framework ini mengikuti industry best practices dan siap untuk production use di enterprise environment.

---

**📞 Support:**
- GitHub Issues untuk bug reports
- GitHub Discussions untuk questions
- Pull Requests untuk contributions

**📖 Resources:**
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Selenium Documentation](https://selenium.dev/documentation/)
- [RSpec Documentation](https://rspec.info/)
- [Allure Reports](https://docs.qameta.io/allure/)
