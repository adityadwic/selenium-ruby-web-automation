#!/bin/bash

# Selenium Ruby Web Automation - Advanced Test Runner with Modern Reports
# This script helps you run automation tests with comprehensive reporting

echo "=========================================="
echo "🎯 Selenium Ruby Automation Framework"
echo "📊 Advanced Test Runner with Modern Reports"
echo "=========================================="
echo ""

# Function to display help
show_help() {
    echo "Usage: ./run_tests.sh [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --browser chrome|firefox|safari   Set browser (default: chrome)"
    echo "  --headless                        Run in headless mode"
    echo "  --env test|staging|production     Set environment (default: test)"
    echo "  --tag smoke|regression            Run specific test tags"
    echo "  --reports all|html|json|allure    Generate specific reports (default: all)"
    echo "  --parallel                        Run tests in parallel"
    echo "  --help                           Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./run_tests.sh                    # Run all tests with all reports"
    echo "  ./run_tests.sh --browser firefox  # Run tests in Firefox"
    echo "  ./run_tests.sh --headless         # Run tests in headless mode"
    echo "  ./run_tests.sh --tag smoke        # Run only smoke tests"
    echo "  ./run_tests.sh --reports html     # Generate only HTML report"
    echo "  ./run_tests.sh --parallel         # Run tests in parallel"
    echo ""
}

# Default values
BROWSER="chrome"
HEADLESS=""
ENV_VAR="test"
TAG=""
REPORTS="all"
PARALLEL=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --browser)
            BROWSER="$2"
            shift 2
            ;;
        --headless)
            HEADLESS="true"
            shift
            ;;
        --env)
            ENV_VAR="$2"
            shift 2
            ;;
        --tag)
            TAG="$2"
            shift 2
            ;;
        --reports)
            REPORTS="$2"
            shift 2
            ;;
        --parallel)
            PARALLEL="true"
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Validate inputs
if [[ ! "$BROWSER" =~ ^(chrome|firefox|safari)$ ]]; then
    echo "❌ Error: Invalid browser '$BROWSER'. Use chrome, firefox, or safari."
    exit 1
fi

if [[ ! "$ENV_VAR" =~ ^(test|staging|production)$ ]]; then
    echo "❌ Error: Invalid environment '$ENV_VAR'. Use test, staging, or production."
    exit 1
fi

if [[ ! "$REPORTS" =~ ^(all|html|json|allure)$ ]]; then
    echo "❌ Error: Invalid reports option '$REPORTS'. Use all, html, json, or allure."
    exit 1
fi

# Set environment variables
export BROWSER="$BROWSER"
export ENV="$ENV_VAR"

if [[ -n "$HEADLESS" ]]; then
    export HEADLESS="$HEADLESS"
fi

# Display configuration
echo "📋 Configuration:"
echo "   Browser: $BROWSER"
echo "   Environment: $ENV_VAR"
echo "   Headless: ${HEADLESS:-false}"
echo "   Reports: $REPORTS"
if [[ -n "$TAG" ]]; then
    echo "   Tag: $TAG"
fi
if [[ -n "$PARALLEL" ]]; then
    echo "   Parallel: enabled"
fi
echo ""

# Check dependencies
echo "🔍 Checking dependencies..."
if ! bundle check > /dev/null 2>&1; then
    echo "📦 Installing dependencies..."
    bundle install
    echo "✅ Dependencies installed!"
else
    echo "✅ Dependencies are up to date!"
fi
echo ""

# Prepare directories
echo "📁 Preparing report directories..."
mkdir -p reports/{screenshots,allure-results}
rm -rf reports/*.html reports/*.json reports/screenshots/* reports/allure-results/*
echo "✅ Directories prepared!"
echo ""

# Build RSpec command
RSPEC_CMD="bundle exec rspec"

# Add formatters based on reports option
case $REPORTS in
    "all")
        RSPEC_CMD="$RSPEC_CMD --format RSpec::Core::Formatters::DocumentationFormatter"
        RSPEC_CMD="$RSPEC_CMD --format ModernHtmlFormatter --out reports/test_report.html"
        RSPEC_CMD="$RSPEC_CMD --format JsonReporter --out reports/test_results.json"
        RSPEC_CMD="$RSPEC_CMD --format AllureRspecFormatter"
        ;;
    "html")
        RSPEC_CMD="$RSPEC_CMD --format ModernHtmlFormatter --out reports/test_report.html"
        ;;
    "json")
        RSPEC_CMD="$RSPEC_CMD --format JsonReporter --out reports/test_results.json"
        ;;
    "allure")
        RSPEC_CMD="$RSPEC_CMD --format AllureRspecFormatter"
        ;;
esac

# Add tag filter if specified
if [[ -n "$TAG" ]]; then
    RSPEC_CMD="$RSPEC_CMD --tag $TAG"
fi

# Add parallel execution if specified
if [[ -n "$PARALLEL" ]]; then
    RSPEC_CMD="bundle exec parallel_rspec spec/"
fi

# Run tests
echo "🚀 Running tests..."
echo "📄 Command: $RSPEC_CMD"
echo "=========================================="

START_TIME=$(date +%s)
eval $RSPEC_CMD
TEST_EXIT_CODE=$?
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

echo ""
echo "=========================================="
echo "⏱️  Test execution completed in ${DURATION}s"

# Generate additional reports
if [[ "$REPORTS" == "all" || "$REPORTS" == "allure" ]]; then
    echo ""
    echo "📊 Generating additional reports..."
    
    # Check if allure is installed
    if command -v allure &> /dev/null; then
        echo "🎨 Generating Allure report..."
        allure generate reports/allure-results --clean -o reports/allure-report
        echo "✅ Allure report generated: reports/allure-report/index.html"
    else
        echo "⚠️  Allure not installed. Install with: npm install -g allure-commandline"
    fi
fi

# Display results
echo ""
if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo "🎉 All tests passed successfully!"
else
    echo "❌ Some tests failed. Check the reports for details."
fi

echo ""
echo "📊 Generated Reports:"
if [[ "$REPORTS" == "all" || "$REPORTS" == "html" ]]; then
    echo "   📄 Modern HTML Report: reports/test_report.html"
    echo "   📈 Test Dashboard: reports/dashboard.html"
fi
if [[ "$REPORTS" == "all" || "$REPORTS" == "json" ]]; then
    echo "   📋 JSON Report: reports/test_results.json"
fi
if [[ "$REPORTS" == "all" || "$REPORTS" == "allure" ]]; then
    echo "   🎨 Allure Results: reports/allure-results/"
    if [ -d "reports/allure-report" ]; then
        echo "   🌟 Allure Report: reports/allure-report/index.html"
    fi
fi
echo "   📸 Screenshots: reports/screenshots/"

echo ""
echo "🔥 Quick Commands:"
echo "   View HTML Report: open reports/test_report.html"
echo "   View Dashboard: open reports/dashboard.html"
if [ -d "reports/allure-report" ]; then
    echo "   View Allure Report: open reports/allure-report/index.html"
else
    echo "   Generate Allure Report: allure serve reports/allure-results"
fi

echo ""
echo "=========================================="

exit $TEST_EXIT_CODE
