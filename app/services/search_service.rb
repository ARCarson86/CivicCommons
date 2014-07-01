class SearchService

  def initialize(search = nil)
    if search.nil?
      # called by search controller since nothing was passed in
      @search = Sunspot
    else
      # called by search spec since a mock was passed in
      @search = search
    end
  end

  def fetch_results(query = nil, options = {})
    models = [options.delete(:models)]
    fields = accepted_fields(models)
    fields[:fragment_size] = -1
    region_metrocodes = options.delete(:region_metrocodes)
    
    results = @search.search(models) do
      keywords(query) do
        highlight fields
      end
      
      # If region_metrocodes present, then filter conversation and issues, Contribution, and ignore filter an other objects
      if region_metrocodes.present?
        classes_with_regional_metrocodes = [Conversation, ManagedIssue, Contribution]
        any_of do
          all_of do
             with(:class, classes_with_regional_metrocodes)
             with(:region_metrocodes, region_metrocodes) 
          end
          without(:class, classes_with_regional_metrocodes)
        end
        
      end
    end

    results.hits({ verify: true }).reject do |hit|
      hit.result.is_a?(Contribution) and not hit.result.confirmed?
    end
  end

  def fetch_filtered_results(query = nil, filter = nil, options = {})
    models = [options.delete(:models)]
    fields = accepted_fields(models)
    fields[:fragment_size] = -1
    region_metrocodes = options.delete(:region_metrocodes)
    results = @search.search(models) do
      with(:content_type, 'BlogPost') if filter == 'blogs'
      with(:type, 'Issue') if filter == 'issues'
      case filter
      when 'projects'
        any_of do
          with(:type, 'ManagedIssue')
          with(:type, 'ManagedIssuePage')
        end
      when 'issues', 'conversations', 'contributions'
        with(:region_metrocodes, region_metrocodes) if region_metrocodes.present?
      end
      keywords(query) do
        highlight fields
      end
    end

    results.hits({ verify: true }).reject do |hit|
      hit.result.is_a?(Contribution) and not hit.result.confirmed?
    end
  end

  def accepted_fields(models)
    fields = {}
    i = 0 
    models.each do |mod|
      case 
      when mod == Contribution then
        fields[i] = :content
      when mod == Conversation then
        fields[i] = :summary
      when mod == Person then
        fields[i] = :bio
      when mod == Issue then
        fields[i] = :summary
      when mod == ManagedIssuePage then
        fields[i] = :template
      when mod == ContentItem then
        fields[i] = :body
        i = i + 1
        fields[i] = :summary
      end
      i = i + 1
    end
    return fields
  end
end
