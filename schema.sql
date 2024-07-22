DROP TABLE IF EXISTS shifts;
DROP TABLE IF EXISTS workplaces;

CREATE TABLE workplaces (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL
);

CREATE TABLE shifts (
  id SERIAL PRIMARY KEY,
  shift_date DATE NOT NULL,
  shift_type TEXT NOT NULL,
  tip_amount NUMERIC(5, 2) NOT NULL,
  workplace_id INT NOT NULL, 
  FOREIGN KEY (workplace_id) REFERENCES workplaces (id)
    ON DELETE CASCADE,
  UNIQUE (shift_date, shift_type)
);


INSERT INTO workplaces (name)
  VALUES  ('The Beehive Grill'),
          ('Whiskey Cake'),
          ('Babysit Ryan'),
          ('Bon Appetit Cafe & Bakery'),
          ('The Cheesecake Factory'),
          ('Rover'),
          ('Olive Garden'),
          ('Nanny for the Smiths'),
          ('Shake Shack'),
          ('Chick-fil-A'),
          ('P.F. Chang''s'),
          ('Red Lobster'),
          ('Instacart'),
          ('Five Guys');

INSERT INTO shifts (shift_date, shift_type, tip_amount, workplace_id)
  VALUES  ('2020-01-01', 'Morning', 25.50, 1),
          ('2020-02-15', 'Afternoon', 18.75, 1),
          ('2020-03-05', 'Afternoon', 30.00, 1),
          ('2020-04-20', 'Morning', 22.00, 1),
          ('2020-05-10', 'Afternoon', 15.25, 1),
          ('2020-06-02', 'Morning', 28.75, 1),
          ('2020-07-15', 'Morning', 19.50, 1),
          ('2020-08-05', 'Afternoon', 21.25, 1),
          ('2020-09-18', 'Night', 35.00, 1),
          ('2020-10-10', 'Morning', 24.75, 1),
          ('2020-11-22', 'Afternoon', 17.50, 1),
          ('2020-12-03', 'Night', 32.25, 1),
          ('2021-01-15', 'Morning', 26.50, 1),
          ('2021-03-08', 'Afternoon', 20.75, 1),
          ('2021-05-25', 'Night', 33.50, 1);

INSERT INTO shifts (shift_date, shift_type, tip_amount, workplace_id) 
  VALUES  ('2020-02-01', 'Morning', 28.00, 2),
          ('2020-02-15', 'Night', 19.75, 2),
          ('2020-03-05', 'Night', 31.50, 2),
          ('2020-04-10', 'Morning', 23.25, 2),
          ('2020-05-20', 'Afternoon', 16.50, 2),
          ('2020-06-02', 'Night', 29.75, 2),
          ('2020-07-10', 'Morning', 20.50, 2),
          ('2020-07-25', 'Afternoon', 22.25, 2),
          ('2020-08-18', 'Night', 34.00, 2),
          ('2020-03-01', 'Morning', 25.50, 2),
          ('2020-03-15', 'Afternoon', 18.75, 2),
          ('2020-04-05', 'Night', 30.00, 2),
          ('2020-05-20', 'Morning', 22.00, 2),
          ('2020-06-10', 'Afternoon', 15.25, 2),
          ('2020-08-02', 'Night', 28.75, 2);

INSERT INTO shifts (shift_date, shift_type, tip_amount, workplace_id) 
  VALUES  ('2020-07-05', 'Morning', 26.00, 3),
          ('2020-07-12', 'Afternoon', 17.75, 3),
          ('2020-07-18', 'Night', 29.50, 3),
          ('2020-07-24', 'Morning', 21.25, 3),
          ('2020-07-30', 'Afternoon', 14.50, 3);

INSERT INTO shifts (shift_date, shift_type, tip_amount, workplace_id) 
  VALUES  ('2020-09-01', 'Morning', 24.00, 4),
          ('2020-09-15', 'Afternoon', 16.75, 4),
          ('2020-10-05', 'Night', 28.50, 4),
          ('2020-11-10', 'Morning', 20.25, 4),
          ('2020-12-20', 'Afternoon', 13.50, 4),
          ('2021-01-02', 'Night', 26.75, 4),
          ('2021-02-10', 'Morning', 18.50, 4),
          ('2021-03-25', 'Afternoon', 20.25, 4),
          ('2021-04-18', 'Night', 32.00, 4),
          ('2021-05-10', 'Morning', 23.50, 4),
          ('2021-06-15', 'Afternoon', 15.75, 4),
          ('2021-07-05', 'Night', 28.50, 4);

INSERT INTO shifts (shift_date, shift_type, tip_amount, workplace_id) 
  VALUES  ('2020-10-01', 'Morning', 22.00, 5),
          ('2020-10-15', 'Afternoon', 14.75, 5),
          ('2020-11-05', 'Night', 26.50, 5),
          ('2020-12-10', 'Morning', 18.25, 5),
          ('2021-01-20', 'Afternoon', 11.50, 5),
          ('2021-02-02', 'Night', 24.75, 5),
          ('2021-03-10', 'Night', 16.50, 5),
          ('2021-04-25', 'Afternoon', 18.25, 5),
          ('2021-05-18', 'Night', 30.00, 5),
          ('2021-06-10', 'Night', 21.50, 5),
          ('2021-07-15', 'Afternoon', 13.75, 5),
          ('2021-08-05', 'Night', 26.50, 5);

INSERT INTO shifts (shift_date, shift_type, tip_amount, workplace_id) 
  VALUES  ('2020-11-01', 'Morning', 25.00, 6),
          ('2020-11-15', 'Afternoon', 17.75, 6),
          ('2020-12-05', 'Night', 29.50, 6),
          ('2021-07-10', 'Morning', 24.50, 6),
          ('2021-08-15', 'Afternoon', 16.75, 6),
          ('2021-09-05', 'Night', 29.50, 6);

INSERT INTO shifts (shift_date, shift_type, tip_amount, workplace_id) 
  VALUES  ('2021-01-01', 'Morning', 22.00, 7),
          ('2021-01-15', 'Afternoon', 14.75, 7),
          ('2021-02-05', 'Night', 26.50, 7),
          ('2021-03-10', 'Morning', 18.25, 7),
          ('2021-04-20', 'Afternoon', 11.50, 7),
          ('2021-05-02', 'Night', 24.75, 7),
          ('2021-06-10', 'Morning', 16.50, 7),
          ('2021-07-25', 'Afternoon', 18.25, 7),
          ('2021-08-18', 'Night', 30.00, 7),
          ('2021-09-10', 'Morning', 21.50, 7),
          ('2021-10-15', 'Night', 13.75, 7),
          ('2021-11-05', 'Morning', 26.50, 7);

INSERT INTO shifts (shift_date, shift_type, tip_amount, workplace_id) 
  VALUES  ('2021-04-01', 'Morning', 25.00, 8),
          ('2021-04-15', 'Afternoon', 17.75, 8),
          ('2022-02-05', 'Night', 29.50, 8);

INSERT INTO shifts (shift_date, shift_type, tip_amount, workplace_id) 
  VALUES  ('2021-10-01', 'Morning', 22.00, 9),
          ('2021-10-15', 'Afternoon', 14.75, 9),
          ('2021-11-05', 'Night', 26.50, 9),
          ('2021-12-10', 'Morning', 18.25, 9),
          ('2022-01-20', 'Afternoon', 11.50, 9),
          ('2022-02-02', 'Night', 24.75, 9),
          ('2022-03-10', 'Morning', 16.50, 9),
          ('2022-04-25', 'Afternoon', 18.25, 9),
          ('2022-05-18', 'Night', 30.00, 9),
          ('2022-06-10', 'Morning', 21.50, 9),
          ('2022-07-15', 'Afternoon', 13.75, 9),
          ('2022-08-05', 'Night', 26.50, 9);

INSERT INTO shifts (shift_date, shift_type, tip_amount, workplace_id) 
  VALUES  ('2022-02-01', 'Morning', 25.00, 10),
          ('2022-02-15', 'Afternoon', 17.75, 10),
          ('2022-03-05', 'Night', 29.50, 10),
          ('2022-04-10', 'Morning', 21.25, 10),
          ('2022-05-20', 'Afternoon', 14.50, 10),
          ('2022-06-02', 'Night', 27.75, 10),
          ('2022-07-10', 'Morning', 19.50, 10),
          ('2022-07-25', 'Afternoon', 21.25, 10),
          ('2022-08-18', 'Night', 33.00, 10),
          ('2022-09-10', 'Morning', 24.50, 10),
          ('2022-10-15', 'Afternoon', 16.75, 10),
          ('2022-11-05', 'Night', 29.50, 10);

INSERT INTO shifts (shift_date, shift_type, tip_amount, workplace_id) 
  VALUES  ('2022-12-01', 'Morning', 27.00, 11),
          ('2022-12-15', 'Afternoon', 18.75, 11),
          ('2023-01-05', 'Night', 30.50, 11),
          ('2023-02-10', 'Night', 22.25, 11),
          ('2023-03-20', 'Afternoon', 15.50, 11),
          ('2023-04-02', 'Night', 28.75, 11),
          ('2023-05-10', 'Afternoon', 20.50, 11),
          ('2023-06-25', 'Afternoon', 22.25, 11),
          ('2023-07-18', 'Night', 34.00, 11),
          ('2023-02-01', 'Morning', 26.50, 11),
          ('2023-02-15', 'Afternoon', 19.75, 11),
          ('2023-03-05', 'Night', 31.00, 11);

INSERT INTO shifts (shift_date, shift_type, tip_amount, workplace_id) 
  VALUES  ('2022-09-01', 'Morning', 24.00, 12),
          ('2022-09-15', 'Afternoon', 16.75, 12),
          ('2022-10-05', 'Night', 28.50, 12),
          ('2022-11-10', 'Morning', 20.25, 12),
          ('2022-12-20', 'Afternoon', 13.50, 12),
          ('2023-01-02', 'Night', 26.75, 12),
          ('2023-02-10', 'Morning', 18.50, 12),
          ('2023-03-25', 'Afternoon', 20.25, 12),
          ('2023-04-18', 'Night', 32.00, 12),
          ('2023-05-10', 'Morning', 23.50, 12),
          ('2023-06-15', 'Night', 15.75, 12),
          ('2023-07-05', 'Morning', 28.50, 12);

INSERT INTO shifts (shift_date, shift_type, tip_amount, workplace_id) 
  VALUES  ('2023-04-01', 'Morning', 25.00, 13),
          ('2023-04-15', 'Afternoon', 17.75, 13),
          ('2023-05-05', 'Night', 29.50, 13),
          ('2023-06-10', 'Morning', 21.25, 13),
          ('2023-06-20', 'Afternoon', 14.50, 13),
          ('2023-07-02', 'Night', 27.75, 13),
          ('2023-07-10', 'Night', 19.50, 13),
          ('2023-07-25', 'Afternoon', 21.25, 13),
          ('2023-08-01', 'Morning', 25.50, 13),
          ('2023-08-15', 'Afternoon', 18.75, 13),
          ('2023-09-05', 'Night', 30.00, 13);

INSERT INTO shifts (shift_date, shift_type, tip_amount, workplace_id) 
  VALUES  ('2023-06-01', 'Morning', 26.00, 14),
          ('2023-06-15', 'Afternoon', 17.75, 14),
          ('2023-07-05', 'Night', 29.50, 14),
          ('2023-07-10', 'Morning', 21.25, 14),
          ('2023-07-20', 'Afternoon', 14.50, 14),
          ('2023-08-02', 'Night', 27.75, 14),
          ('2023-08-10', 'Morning', 19.50, 14),
          ('2023-08-25', 'Afternoon', 21.25, 14),
          ('2023-09-18', 'Night', 33.00, 14),
          ('2023-10-01', 'Morning', 25.50, 14),
          ('2023-10-15', 'Afternoon', 18.75, 14),
          ('2023-11-05', 'Night', 30.00, 14);