module ConstMissing

end

def Object.const_missing(name)
  # Logger_.debug "ActiveMocker :: Can't can't find Constant #{name} from class #{}."
end
