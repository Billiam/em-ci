module CcTray
  class Project
    attr_accessor :name, :url, :time, :status, :activity

    def initialize(data)
      import(data)
    end

    def import(data)
      self.name     = data['name']
      self.url      = data['webUrl']
      self.time     = data['lastBuildTime']
      self.status   = data['lastBuildStatus']
      self.activity = data['activity']
    end

    def building?
      activity == 'Building'
    end

    def sleeping?
      activity == 'Sleeping'
    end

    def success?
      status == 'Success'
    end

    def failure?
      status == 'Failure'
    end
  end
end
