# puppet-lint hiera functions check

[![Gem Version](https://badge.fury.io/rb/puppet-lint-hiera.svg)](https://badge.fury.io/rb/puppet-lint-hiera)

## Installation
To add the provided lint checks into a module utilizing the PDK:

1. Add the following to the `.sync.yml` in the root of your module
   ``` yaml
   ---
   Gemfile:
     optional:
       ':development':
         - gem: 'puppet-lint-hiera'
   ```
2. Run `pdk update` from the root of the module
3. `pdk validate` will now also use the lint checks provided by this plugin

## Usage
This plugin provides two new checks to `puppet-lint`

### **no_hiera**
`--fix` support: No

This check raises an error if the `hiera()` function is used.
```
error: hiera() function call. Use lookup() instead.
```

### **lookup_in_class**
`--fix` support: No

This check raises an error if the `lookup()` function is used within a class body.
```
error: lookup() function call found in class.
```

### **lookup_in_class_params**
`--fix` support: No

This check raises an error if the `lookup()` function is used inside a classes parameters.
```
error: lookup() function call found in class params.
```

### **lookup_in_profile_class**
`--fix` support: No

This check raises an error if the `lookup()` function is used within a profile body.
```
error: lookup() function call found in profile class. Only use in profile params.
```
