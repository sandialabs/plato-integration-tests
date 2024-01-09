# integration_tests
Contains tests for integration of Platoengine with other apps

## Directory structure

The top-level directory structure of this repository should reflect the codes required for the integration tests.
In other words, there should be a top-level directory for each different code that has integration tests.
For example:

    integration_tests
    | 
    ├─ Analyze
    |  |
    |  ├─ gradient_check
    |  ├─ examples
    |  ├─ regression
    |
    ├─ Proxy
    |  |
    |  ├─ gradient_check
    |  ├─ examples
    |  ├─ regression

The `utilities` and `common_data` directory are intended for common cmake and python utilities that all tests may share, as well as any large data files such as exodus meshes.