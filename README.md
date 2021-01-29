# Deltics.Radiata

A logging framework inspired by Serilog.


## Installation

If using duget: Add `deltics.radiata` to your project `.duget` dependencies and run `duget update`
to get the latest version.  Then run `duget restore` to update your project path.

If not using duget: Download the source and manually add to your project path settings.


# Getting Started

## Log Configuration

Before you can output to any log with Radiata, you must first configure a log.  Configuration
includes identifying the minimum level of detail in the log and identifying the "sinks" or targets
to receive log information.

Supported log sinks are:

* Console (stdout)
* Debugger (OutputDebugString on Windows)
* Windows' Event Log
* A specified file (not yet implemented)
* A custom sink provided by the application

The log configuration also determines the minimum detail level for the log.  The default is "info".

To configure a log, use the configuration object returned by `LoggerConfiguration` to configure and
the log with a minimum level and the desired targets or sinks:

    logger := LoggerConfiguration;
    logger.MinimumLevel(lvHint);
    logger.Send
      .ToConsole
      .ToDebugger;

The sink configuration methods can be chained to send log output to multiple sinks, as illustrated.

Once the configuration is complete you can then create a log with that configuration using one of:

* CreateDefault
* CreateNull
* CreateLogger

`CreateDefault` will create a log and install it as the default logger, if no other
log has yet been created as the default

`CreateNull` ignores any configuration and installs a null logger as the default.  A null logger
ignores all logging (not log output is produced, regardless of configuration).

`CreateLogger` creates a custom log which is returned from the function.  To log using that custom
log you must retain a reference to it and use that reference to perform your logging operations.

Any output set to the default log (via the `Log` object, will NOT be sent to any custom logs.


## Sending Output To A Log

To output information to a log in your application use the method of the default `Log` object or
a custom log reference, appropriate to the nature of the information you are logging.  Available
methods are:

* Debug
* Verbose
* Info
* Hint
* Warning
* Error
* Fatal

**Debug** is additional output not included even in verbose output,

**Verbose** should be used for output that is output when additional logging is requested,

**Info** should be used for output that is intended always to be logged,

**Hint** should be used for output that may be of additional interest but is not necessarily
unexpected,

**Warning** should be used for output that highlights some possibly unexpected condition,

**Error** should be used for output that indicates some error from which your application has
recovered,

**Fatal** should be used for output that reports an unrecoverable error that has caused your
application to terminate some process or to exit entirely.

The Log is configured with a minimum level of detail (see Log Configuration above).  Only
information output at the specified minimum log level or above will be output.  All other
information will be ignored and will not be output.

All of the methods provide two overloaded forms.  The first accepts a simple string to be output.
The second accepts a string that contains tokenised elements to be substituted with values provided
in a `const array`.  For example:

    Info('This is a simple information message');
    Hint('The file ''{filename}'' did not exist and was created', [aInputFilename]);

Tokens in the string are delimited by curly braces `{}` and contain a name for a value provided
in the const array.  By default, it is assumed that the values in the const array are strings.
If values of other types are supplied, the framework will do its best to convert them to a string,
but you can provide specific formatting appended to the token name following a colon, in the form
of the usual format strings supported by the `SysUtils.Format()` method.

For example, to format an integer value (`addrCount`):

    Hint('Customer {customerId} has {numAddresses:%d} addresses on file', [custId, addrCount]);


You do not identify the index of the value to be substituted for a given token.

This is determined by the position order in which tokens are identified in the string.  The first
token is value 0, the second token is value 1, etc.  If a token in a string is repeated then it
will apply the value determined by the position of the first occurence of that token:

    Hint('''{filename}'' did not exist in {filepath}.  ''{filename}'' was created', [aInputFilename, aFilePath]);

`aInputFilename` is substituted for both occurences of `{filename}`.
