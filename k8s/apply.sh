#!/bin/sh

helm upgrade yacy -n yacy --create-namespace --install ./ -f values.yaml
