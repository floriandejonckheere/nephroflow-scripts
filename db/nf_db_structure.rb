#!/usr/bin/env ruby

REVERSE = (ARGV.first == "reverse")

# Read structure.sql
structure = File.readlines(File.join(ENV["NF_PATH"], "nephroflow-api/db/structure.sql"))

# Find the index of the schema migrations
index = structure.index { |l| l.start_with?("INSERT INTO \"schema_migrations\"") }

raise "Merge conflict found before schema migrations. Please resolve the conflict manually." if structure[..index].any? { |l| l.start_with?("<<<<<<<", "=======", ">>>>>>>") }

# Get the migrations
migrations = structure[(index + 1)..]

# Drop trailing empty lines
migrations.reject!(&:empty?)

# Drop git conflict delimiters
migrations.reject! { |l| l.start_with?("<<<<<<<", "=======", ">>>>>>>") }

# Replace semicolons with commas
migrations.map! { |l| l.tr(";", ",") }

# Sort and deduplicate
migrations.sort!
migrations.reverse! if REVERSE
migrations.uniq!

# Add semicolon to last statement
migrations[-1].tr!(",", ";")

# Write structure.sql
File.write("db/structure.sql", (structure[..index] + migrations).join)

puts "Resolved merge conflicts in db/structure.sql"
