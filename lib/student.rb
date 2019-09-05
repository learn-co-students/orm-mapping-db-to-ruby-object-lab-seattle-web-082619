# frozen_string_literal: true

class Student
  attr_accessor :id, :name, :grade

  def initialize(person = [])
    self.id = person[0]
    self.name = person[1]
    self.grade = person[2]
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, name, grade)
  end

  def self.new_from_db(row)
    Student.new(row)
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    rows = DB[:conn].execute(sql)
    rows.map(&Student)
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
    SQL

    first_row = DB[:conn].execute(sql, name)[0]
    new_from_db(first_row)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 9
    SQL

    rows = DB[:conn].execute(sql)
    rows.map(&Student)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12
    SQL

    rows = DB[:conn].execute(sql)
    rows.map(&Student)
  end

  def self.first_X_students_in_grade_10(amount)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT ?
    SQL

    rows = DB[:conn].execute(sql, amount)
    rows.map(&Student)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT 1
    SQL

    row = DB[:conn].execute(sql)
    row.map(&Student)[0]
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
    SQL

    rows = DB[:conn].execute(sql, grade)
    rows.map(&Student)
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
    sql = 'DROP TABLE IF EXISTS students'
    DB[:conn].execute(sql)
  end

  # Proc on Student calls new
  def self.to_proc
    proc(&method(:new))
  end
end
