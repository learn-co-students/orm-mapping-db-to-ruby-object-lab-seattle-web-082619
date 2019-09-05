require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
 end

  def self.all

    sql = <<-SQL
      SELECT * FROM students
    SQL

    all_rows = DB[:conn].execute(sql) #array of arrays

    all_rows.map { |row| self.new_from_db(row) }

  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE students.name = name
    SQL

    student_row_as_array = DB[:conn].execute(sql) #--this is returning an ARRAY of ARRAY(s) (here just 1) with the raw student data

    self.new_from_db(student_row_as_array.first)

    # find the student in the database given a name
    # return a new instance of the Student class
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
      grade INTEGER
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end


  def self.all_students_in_grade_9
    self.all.select {|student| student.grade == 9}
  end

  def self.students_below_12th_grade
    self.all.select {|student| student.grade < 12}
  end

  def self.first_X_students_in_grade_10(x)
    self.all.select {|student| student.grade == 10}.slice(0...x)
  end

  def self.first_student_in_grade_10
    self.all.find {|student| student.grade == 10}
  end

  def self.all_students_in_grade_X(x)
    self.all.select {|student| student.grade == x}
  end

end
