#!/bin/sh
cd "$(dirname "$0")"
pandoc ./summary.md -o ./summary.pdf --toc-depth=2
echo "Generated PDF"