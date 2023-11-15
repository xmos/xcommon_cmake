.. _`dependency-format`:

Dependency Format
-----------------

The ``APP_DEPENDENT_MODULES`` and ``LIB_DEPENDENT_MODULES`` variables hold the list of module dependencies
for an application, module or static library. The format is flexible to support releases to external users
and also internal development practices.

External releases use this format:

1. ``lib_abc(1.2.3)``
     get lib_abc tag v1.2.3 from github.com/xmos; a check is made to see if SSH key access is available,
     otherwise HTTPS is used. The 'v' character is prepended so the released tag must be v1.2.3

For internal development, there are ways to specify the location and version.

Firstly the location can be specified at the beginning of the string:

2. ``lib_abc``
     uses ``github.com/xmos`` as the location from which to clone lib_abc; same behaviour as format 1 for SSH/HTTPS access

3. ``myuser/lib_abc``
     clones lib_abc from ``github.com/myuser``; same behaviour as format 1 for SSH/HTTPS access

4. ``othergitserver.com:myuser/lib_abc``
     SSH access to clone ``git@othergitserver.com:myuser/lib_abc``

5. ``https://othergitserver.com/myuser/lib_abc``
     clones this URL via HTTPS, without checking for SSH access

Then the version can be specified at the end of the string:

6. ``lib_abc``
     no version specified, gets the head of whichever branch has been configured as the default

7. ``lib_abc(v1.2.3)``
     acceptable alternative to format 1, gets tag v1.2.3

8. ``lib_abc(develop)``
     gets the head of the develop branch

9. ``lib_abc(4fa35fe)``
     gets commit 4fa35fe

Any of formats 2-5 can be combined with any of 6-9 to specify both the location and the version. For example:

.. code-block:: cmake

    set(APP_DEPENDENT_MODULES "myuser/lib_abc(develop)"
                              "othergitserver.com:myuser/lib_foo(1.0.0)")

- check out the head of the develop branch of lib_abc from ``github.com/myuser``, using an SSH key if available,
  otherwise via HTTPS.
- check out tag v1.0.0 of lib_foo, cloned from ``othergitserver.com/myuser`` via SSH access.
