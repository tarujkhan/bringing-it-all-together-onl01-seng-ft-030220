class Dog 
  attr_accessor :id, :name, :breed 
  
  def initialize(id: nil, name:, breed:)
     @id = id
    @name = name 
    @breed = breed 
  end 
  
  def self.create_table 
    sql = <<-SQL 
    CREATE TABLE IF NOT EXISTS dogs (id INTEGER PRIMARY KEY, name TEXT, breed TEXT)
    SQL
    DB[:conn].execute(sql) 
  end 
  
  def save
    sql = <<-SQL
    INSERT INTO dogs (name, breed) VALUES (?, ?)
    SQL
   
    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute(SELECT last_insert_row_id)
  end 
  
  def self.drop_table
    sql = "DROP TABLE dogs"
    DB[:conn].execute(sql)
  end 
  
  def self.create(name, breed)
    new_dog = self.new(name, breed)
    new_dog
  end 
  
  def self.new_from_db
    id = row[0]
    name = row[1]
    breed = row[2]
    new_dog = self.new(id, name, breed)
  end 
  
  def self.find_by_id(id)
    new_dog = DB[:conn].execute("FIND BY id WHERE id = ?", [id])[0][0]
    id = new_dog[0]
    name = new_dog[1]
    breed = new_dog[2]
    new_dog = self.new(id:id, name:name, breed:breed)
  end 
  
  def self.find_or_create_by(name, breed)
    new_dog = DB[:conn].execute("SELECT FROM dogs WHERE name = ? AND breed = ?", name, breed)
    if !new_dog.empty
      dog_data = new_dog[0]
      new_dog = self.new(dog_data[0], dog_data[1], dog_data[2])
    else 
      new_dog = self.create(name, breed)
    end 
    new_dog
  end 
      
  def self.find_by_name(name)
    new_dog = DB[:conn].execute("FIND BY id WHERE name = ?", [name])[0][0]
    id = new_dog[0]
    name = new_dog[1]
    breed = new_dog[2]
    new_dog = self.new(id:id, name:name, breed:breed)
  end 
  
  def update 
    sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
    DB[:conn].execute(sql, self.id, self.name, self.breed)
  end 
end 
  