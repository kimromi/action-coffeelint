#!/bin/sh
env

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1

pwd
ls -la
git --version
whoami
cat /etc/passwd

if [ ! -f "$(npm bin)/coffeelint" ]; then
  npm install
fi

$(npm bin)/coffeelint --version

$(npm bin)/coffeelint --reporter checkstyle ${INPUT_COFFEELINT_FLAGS:-'.'} \
    | reviewdog -f="checkstyle" \
        -name="${INPUT_TOOL_NAME}" \
        -reporter="${INPUT_REPORTER:-github-pr-check}" \
        -filter-mode="${INPUT_FILTER_MODE}" \
        -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
        -level="${INPUT_LEVEL}" \
        ${INPUT_REVIEWDOG_FLAGS}
