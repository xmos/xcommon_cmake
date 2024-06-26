Static library has multiple "configs" to produce multiple archives. Check that the different build
configs of the app can use the selected archive "config".

The test uses two libs:
- lib_static0: defines two build configs supporting various architectures
- lib_static1: doesn't define any build configs but supports multiple
  architectures
