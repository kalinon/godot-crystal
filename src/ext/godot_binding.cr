module LibGodot
  # Native bindings.  Mostly generated.
  lib Binding
    # Container for string data.
    struct CrystalString
      ptr : LibC::Char*
      size : LibC::Int
    end

    # Container for a `Proc`
    struct CrystalProc
      ptr : Void*
      context : Void*
    end

    # Container for raw memory-data.  The `ptr` could be anything.
    struct CrystalSlice
      ptr : Void*
      size : LibC::Int
    end
  end

  # Helpers for bindings.  Required.
  module BindgenHelper
    # Wraps `Proc` to a `Binding::CrystalProc`, which can then passed on to C++.
    def self.wrap_proc(proc : Proc)
      Binding::CrystalProc.new(
        ptr: proc.pointer,
        context: proc.closure_data,
      )
    end

    # Wraps `Proc` to a `Binding::CrystalProc`, which can then passed on to C++.
    # `Nil` version, returns a null-proc.
    def self.wrap_proc(nothing : Nil)
      Binding::CrystalProc.new(
        ptr: Pointer(Void).null,
        context: Pointer(Void).null,
      )
    end

    # Wraps a *list* into a container *wrapper*, if it's not already one.
    macro wrap_container(wrapper, list)
      %instance = {{ list }}
      if %instance.is_a?({{ wrapper }})
        %instance
      else
        {{wrapper}}.new.concat(%instance)
      end
    end

    # Wrapper for an instantiated, sequential container type.
    #
    # This offers (almost) all read-only methods known from `Array`.
    # Additionally, there's `#<<`.  Other than that, the container type is not
    # meant to be used for storage, but for data transmission between the C++
    # and the Crystal world.  Don't let that discourage you though.
    abstract class SequentialContainer(T)
      include Indexable(T)

      # `#unsafe_at` and `#size` will be implemented by the wrapper class.

      # Adds an element at the end.  Implemented by the wrapper.
      abstract def push(value)

      # Adds *element* at the end of the container.
      def <<(value : T) : self
        push(value)
        self
      end

      # Adds all *elements* at the end of the container, retaining their order.
      def concat(values : Enumerable(T)) : self
        values.each { |v| push(v) }
        self
      end

      def to_s(io)
        to_a.to_s(io)
      end

      def inspect(io)
        io << "<Wrapped "
        to_a.inspect(io)
        io << ">"
      end
    end
  end

  @[Link(ldflags: "#{__DIR__}/../../ext/godot-cpp/bin/libgodot-cpp.osx.debug.64.a")]
  lib Binding
  end

  module Godot
    module Enum
      enum Error : Int32
        Ok                         =  0
        Failed                     =  1
        ErrUnavailable             =  2
        ErrUnconfigured            =  3
        ErrUnauthorized            =  4
        ErrParameterRangeError     =  5
        ErrOutOfMemory             =  6
        ErrFileNotFound            =  7
        ErrFileBadDrive            =  8
        ErrFileBadPath             =  9
        ErrFileNoPermission        = 10
        ErrFileAlreadyInUse        = 11
        ErrFileCantOpen            = 12
        ErrFileCantWrite           = 13
        ErrFileCantRead            = 14
        ErrFileUnrecognized        = 15
        ErrFileCorrupt             = 16
        ErrFileMissingDependencies = 17
        ErrFileEof                 = 18
        ErrCantOpen                = 19
        ErrCantCreate              = 20
        ErrQueryFailed             = 21
        ErrAlreadyInUse            = 22
        ErrLocked                  = 23
        ErrTimeout                 = 24
        ErrCantConnect             = 25
        ErrCantResolve             = 26
        ErrConnectionError         = 27
        ErrCantAquireResource      = 28
        ErrCantFork                = 29
        ErrInvalidData             = 30
        ErrInvalidParameter        = 31
        ErrAlreadyExists           = 32
        ErrDoesNotExist            = 33
        ErrDatabaseCantRead        = 34
        ErrDatabaseCantWrite       = 35
        ErrCompilationFailed       = 36
        ErrMethodNotFound          = 37
        ErrLinkFailed              = 38
        ErrScriptFailed            = 39
        ErrCyclicLink              = 40
        ErrInvalidDeclaration      = 41
        ErrDuplicateSymbol         = 42
        ErrParseError              = 43
        ErrBusy                    = 44
        ErrSkip                    = 45
        ErrHelp                    = 46
        ErrBug                     = 47
        ErrPrinterOnFire           = 48
        ErrOmfgThisIsVeryVeryBad   = 49
        ErrWtf                     = 49
      end
    end
  end
end
