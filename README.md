# Citero

[![CircleCI](https://circleci.com/gh/NYULibraries/citero.svg?style=svg)](https://circleci.com/gh/NYULibraries/citero)

Citero is a program that allows for mapping of data inputs from various systems into one normalized metadata schema
tentatively known as *Citero Standard Form*, or *CSF*. From the normalized schema, *CSF*, it can produce another output
format for use by another system.

## Installation

```ruby
gem 'citero', github: 'NYULibraries/citero', tag: 'v1.0.1'
```

## Usage

```ruby
Citero.map(raw_pnx_json).from_pnx_json.to_bibtex
Citero.map(raw_pnx_json).from_pnx_json.to_openurl
Citero.map(raw_pnx_json).from_pnx_json.to_easybib
Citero.map(raw_pnx_json).from_pnx_json.to_ris
Citero.map(raw_pnx_json).from_pnx_json.to_refworks_tagged
```

### Available import formats

- OpenURL
- PNX (Primo Normalized XML)
- PnxJson (PNX as JSON)

### Available export formats

- OpenURL
- BibTeX
- RIS
- EasyBIB (proprietary JSON)
- Refworks Tagged Format (proprietary RIS)
