INSERT INTO groceries(name) VALUES ('Beer');

INSERT INTO comments (body, grocery_id)
  VALUES ('A crisp malty beverage.', (SELECT id FROM groceries WHERE name ILIKE 'beer'));

INSERT INTO comments (body, grocery_id)
  VALUES ('My favorite beverage!', (SELECT id FROM groceries WHERE name ILIKE 'beer'));

INSERT INTO groceries(name) VALUES ('Peanut Butter');

INSERT INTO groceries(name) VALUES ('Milk');

INSERT INTO groceries(name) VALUES ('Bread');
