require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    self.new.tap do |new_student|
      new_student.id = row[0]
      new_student.name = row[1]
      new_student.grade = row[2]
    end
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM Students"

    DB[:conn].execute(sql).map do |student|
      self.new_from_db(student)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = "SELECT * FROM Students WHERE name = ?"

    DB[:conn].execute(sql, name).map {|student| self.new_from_db(student)}.first
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
    sql = "SELECT * FROM Students WHERE grade = 9"

    DB[:conn].execute(sql).map {|student| self.new_from_db(student)}
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM Students WHERE grade < 12"

    DB[:conn].execute(sql).map {|student| self.new_from_db(student)}
  end

  def self.first_X_students_in_grade_10(num_of_students)
    sql = "SELECT * FROM Students WHERE grade = 10 LIMIT #{num_of_students}"

    DB[:conn].execute(sql).map {|student| self.new_from_db(student)}
  end

  def first_student_in_grade_10
    sql = "SELECT * FROM Students WHERE grade = 10 LIMIT 1"

    DB[:conn].execute(sql).first
  end

end
