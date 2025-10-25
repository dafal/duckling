#!/bin/bash

# Test script for verifying past date bias in Duckling
# This script assumes the duckling-past-bias Docker container is running

DUCKLING_URL="http://localhost:8000/parse"

echo "Testing Duckling with Past Date Bias"
echo "====================================="
echo

# Test 1: "Monday" - should return last Monday, not next
echo "Test 1: Parsing 'Monday'"
curl -s -X POST "$DUCKLING_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "locale": "en_US",
    "text": "Monday",
    "dims": ["time"]
  }' | jq '.'
echo
echo "---"
echo

# Test 2: "March" - should return past March if we're after March
echo "Test 2: Parsing 'March'"
curl -s -X POST "$DUCKLING_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "locale": "en_US",
    "text": "March",
    "dims": ["time"]
  }' | jq '.'
echo
echo "---"
echo

# Test 3: "Friday" - should return last Friday, not next
echo "Test 3: Parsing 'Friday'"
curl -s -X POST "$DUCKLING_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "locale": "en_US",
    "text": "Friday",
    "dims": ["time"]
  }' | jq '.'
echo
echo "---"
echo

# Test 4: "next Monday" - explicit future marker should still work
echo "Test 4: Parsing 'next Monday' (should still be future)"
curl -s -X POST "$DUCKLING_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "locale": "en_US",
    "text": "next Monday",
    "dims": ["time"]
  }' | jq '.'
echo
echo "---"
echo

# Test 5: "last Monday" - explicit past marker should still work
echo "Test 5: Parsing 'last Monday' (should be past)"
curl -s -X POST "$DUCKLING_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "locale": "en_US",
    "text": "last Monday",
    "dims": ["time"]
  }' | jq '.'
echo
echo "---"
echo

# Test 6: "January 15" - should return past January 15 if we're after that date
echo "Test 6: Parsing 'January 15'"
curl -s -X POST "$DUCKLING_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "locale": "en_US",
    "text": "January 15",
    "dims": ["time"]
  }' | jq '.'
echo
echo "---"
echo

echo "All tests complete!"
