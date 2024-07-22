require "pg"

class DatabasePersistence
  def initialize(logger)
    @db = PG.connect(dbname: "tips")
    @logger = logger
  end

  def query(sql, *params)
    @logger.info "#{sql}: #{params}"
    @db.exec_params(sql, params)
  end

  def workplace_names
    sql = "SELECT name FROM workplaces;"
    result = query(sql)
    
    result.map do |tuple|
      { name: tuple["name"] }
    end
  end

  def all_workplaces(per_page, offset)
    sql = <<~SQL
      SELECT w.id, w.name AS workplace,
        SUM(s.tip_amount) AS total_tips,
        COUNT(w.id) OVER () AS total_workplaces,
        SUM(SUM(s.tip_amount)) OVER () AS overall_tips
        FROM workplaces AS w
        LEFT OUTER JOIN shifts AS s
        ON w.id = s.workplace_id
        GROUP BY w.id
        ORDER BY LOWER(w.name)
        LIMIT $1 OFFSET $2;
    SQL

    result = query(sql, per_page, offset)

    result.map do |tuple|
      { id:               tuple["id"].to_i,
        name:             tuple["workplace"],
        total_tips:       tuple["total_tips"].to_f,
        total_workplaces: tuple["total_workplaces"].to_i,
        overall_tips:     tuple["overall_tips"].to_f }
    end
  end

  def get_workplace(id)
    sql = <<~SQL
      SELECT w.id, w.name,
        COUNT(shifts.id) AS shift_count
        FROM workplaces AS w LEFT OUTER JOIN shifts
        ON w.id = shifts.workplace_id
        WHERE w.id = $1
        GROUP BY w.id;
    SQL

    result = query(sql, id)

    tuple = result.first
    { id:           tuple["id"], 
      name:         tuple["name"], 
      shift_count:  tuple["shift_count"].to_i
    } if tuple
  end

  def add_workplace(name)
    sql = "INSERT INTO workplaces (name) VALUES ($1);"
    query(sql, name)
  end

  def update_workplace(id, name)
    sql = <<~SQL
      UPDATE workplaces
      SET name = $1 WHERE id = $2;
    SQL
    query(sql, name, id)
  end

  def delete_workplace(id)
    sql = "DELETE FROM workplaces WHERE id = $1;"
    query(sql, id)
  end

  def all_shifts 
    sql = "SELECT id, shift_date, shift_type FROM shifts;"
    result = query(sql)

    result.map do |tuple|
      { id:   tuple["id"].to_i,
        date: tuple["shift_date"],
        type: tuple["shift_type"] }
    end
  end

  def all_shifts_for_workplace(id, per_page, offset)
    sql = <<~SQL
      SELECT s.id, TO_CHAR(s.shift_date, 'Day') AS day_of_week,
        s.shift_date, s.shift_type, s.tip_amount,
        SUM(s.tip_amount) OVER () AS overall_tips
        FROM shifts AS s INNER JOIN workplaces AS w
        ON s.workplace_id = w.id
        WHERE s.workplace_id = $1
        ORDER BY s.shift_date DESC
        LIMIT $2 OFFSET $3;
    SQL
    result = query(sql, id, per_page, offset)

    result.map do |tuple|
      { id:           tuple["id"].to_i,
        day_of_week:  tuple["day_of_week"],
        date:         tuple["shift_date"],
        type:         tuple["shift_type"],
        tip_amount:   tuple["tip_amount"].to_f,
        overall_tips: tuple["overall_tips"].to_f }
    end
  end

  def get_shift(workplace_id, shift_id)
    sql = <<~SQL
      SELECT * FROM shifts
        WHERE id = $1 AND workplace_id = $2;
    SQL
    result = query(sql, shift_id, workplace_id)

    tuple = result.first
    { id:           tuple["id"].to_i,
      day_of_week:  tuple["day_of_week"],
      date:         tuple["shift_date"],
      type:         tuple["shift_type"],
      tip_amount:   tuple["tip_amount"].to_f } if tuple
  end

  def add_shift(date, type, tip_amount, workplace_id)
    sql = <<~SQL
      INSERT INTO shifts (shift_date, shift_type, tip_amount, workplace_id)
        VALUES ($1, $2, $3, $4);
    SQL
    query(sql, date, type, tip_amount, workplace_id)
  end

  def update_shift(date, type, tip_amount, shift_id, workplace_id)
    sql = <<~SQL
      UPDATE shifts
        SET shift_date = $1,
            shift_type = $2,
            tip_amount = $3
        WHERE id = $4 AND workplace_id = $5;
    SQL

    query(sql, date, type, tip_amount, shift_id, workplace_id)
  end

  def delete_shift(shift_id, workplace_id)
    sql = "DELETE FROM shifts WHERE id = $1 AND workplace_id = $2;"
    query(sql, shift_id, workplace_id)
  end
end