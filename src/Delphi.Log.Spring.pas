unit Delphi.Log.Spring;

interface

uses Spring.Services.Logging, Delphi.Log, Delphi.Log.Logger, Spring.Container;

type
  TSpringLogger = class(TLogger, Delphi.Log.ILogger, Spring.Services.Logging.ILogger)

  end;

implementation

initialization
  GlobalContainer.RegisterType<TSpringLogger>
                 .Implements<Spring.Services.Logging.ILogger>
                 .Implements<Delphi.Log.ILogger>
                 .AsSingleton;

  GlobalContainer.RegisterType<TLoggerFactory>
                 .Implements<Spring.Services.Logging.ILoggerFactory>
                 .Implements<Delphi.Log.ILoggerFactory>
                 .AsSingleton;

end.
