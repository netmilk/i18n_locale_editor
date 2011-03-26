class Hash
  #Finds value in hash by path
  #example: 
  #hash = {
  #  a => 'foo',
  #  b => {
  #    ba => {
  #    bac => 'bar'
  #    }
  #  }
  #}
  #>>>  
  
  def find_by_path(path)
    e ="self"
    path_to_a(path).each{|i| e = e+"['"+ escape_for_eval(i)+ "']" }
    begin 
      eval(e)
    rescue NoMethodError
      return nil
    end
  end


  def update_by_path(path, string)
    return false if find_by_path(path).class == "Hash"
    create_path_if_not_exist(path)
    e ="self"
    path_a = path_to_a(path)
    path_a.each{|i| e = e+"['"+escape_for_eval(i)+"']" }
    string = string.gsub(/^[ \t]+/,"")

    string = escape_for_eval(string)
    e = e+"='"+string+"'"
    begin
      eval(e)
      return true
    rescue => e
      return [false, e]
   end
  end


  def update_by_path_wo_parents(path, string)
    return false if find_by_path(path).class.to_s == "Hash" && find_by_path(path).length > 0
    e ="self"
    path_a = path_to_a(path)
    path_a.each{|i| e = e+"['"+ escape_for_eval(i)+"']" }
    string = escape_for_eval(string)
    e = e+"="+string.inspect+""

    begin
      eval(e)
      return true
    rescue
      return false
    end
  end

  def create_empty_node(path)
    return false if not find_by_path(path).nil?
    update_by_path_wo_parents(path, {})
  end

  def create_path_if_not_exist(path)
    aa = path_to_a(path)
    new_aa = []
    aa.each do |a|
      new_aa << a
      create_empty_node(a_to_path(new_aa))
    end
  end

  def nodes_array(path = [])
    ret = []
    self.each do |key,value|
      if value.class == Hash
        ret = ret + value.nodes_array(path + [key])
      else
        ret << path + [key]
      end
    end
    ret
  end
  
  def paths
    self.nodes_array.map{|i| i.join(".")}
  end

  def next_path(path)
    paths = self.paths
    paths[paths.index(path) + 1]
  end
  
  def previous_path(path)
    paths = self.paths
    paths[paths.index(path) - 1]
  end

  private
  def path_to_a(string)
    string.split(".")
  end

  def a_to_path(array)
    array.join(".")
  end
  
  def escape_for_eval(string)
    
    string.gsub!("'", "\\\\'") if string.class == String
    string
  end
end
