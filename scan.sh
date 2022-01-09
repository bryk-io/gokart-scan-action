#!/bin/sh -eu

# Collect additional parameters
EXTRA_ARGS=""
if [ "${INPUT_GLOBALSTAINTED}" = "yes" ]; then
  EXTRA_ARGS+=" --globalsTainted"
fi
if [ -n "${INPUT_CONFIG}" ]; then
  EXTRA_ARGS+=" --input ${INPUT_CONFIG}"
fi
if [ "${INPUT_VERBOSE}" = "yes" ]; then
  EXTRA_ARGS+=" --verbose"
fi

# Run scan
gokart scan --sarif --output results ${EXTRA_ARGS}
