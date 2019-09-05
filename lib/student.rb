class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    stu = self.new
    stu.id, stu.name, stu.grade = row
    stu
  end

  def self.all
    DB[:conn].execute("SELECT * FROM students;").map { |s| self.new_from_db(s) }
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    sql = "SELECT * FROM students WHERE name == ?;"
    # return a new instance of the Student class
    stu = DB[:conn].execute(sql, name).map { |s| self.new_from_db(s) }.first
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    self.all_students_in_grade_X(9)
  end

  def self.students_below_12th_grade
    self.all.select { |s| s.grade.to_i < 12 }
  end

  def self.first_X_students_in_grade_10(num)
    stu = self.all_students_in_grade_X(10)
    (0...num).map { |i| stu[i] }
  end

  def self.first_student_in_grade_10
    self.all_students_in_grade_X(10).first
  end

  def self.all_students_in_grade_X(num)
    self.all.select { |s| s.grade == num.to_s }
  end

end
