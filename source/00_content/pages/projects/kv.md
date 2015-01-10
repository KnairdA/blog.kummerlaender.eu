# kv

…is a simple CLI-accessible key value store written in Chicken-Scheme and using CSV as a backend.

While this sort of program may be useful for storing some commonly required data in a easily accessible fashion its primary purpose for me is to be used as a _Chicken-Scheme_ tryout _platform_.

The MIT licensed source code may be found on [Github] or [cgit].

## Usage example

|Command                      |Description                                         |
|`kv [show]`                  |List all stores                                     |
|`kv [show] test`             |List all keys of store _test_                       |
|`kv [show] test dummy`       |Print value of key _dummy_ in store _test_          |
|`kv all`                     |List all keys and values of all stores              |
|`kv all test`                |List all keys and values of store _test_            |
|`kv all test dummy`          |Display key and value of key _dummy_ in store _test_|
|`kv write test dummy example`|Write value _example_ to key _dummy_ in store _test_|
|`kv delete test dummy`       |Delete key _dummy_ of store _test_                  |
|`kv rename test dummy dummy2`|Rename key _dummy_ of store _test_ to _dummy2_      |

[Github]: https://github.com/KnairdA/kv/
[cgit]: http://code.kummerlaender.eu/kv/
