class Food:
    def __init__(self, food_id, user_id, date, meal_type, description=None):
        self.food_id = food_id
        self.user_id = user_id
        self.date = date
        self.meal_type = meal_type
        self.description = description

    def to_dict(self):
        return {
            'food_id': self.food_id,
            'user_id': self.user_id,
            'date': str(self.date) if self.date else None,
            'meal_type': self.meal_type,
            'description': self.description,
        }

    @staticmethod
    def from_row(row):
        if row is None:
            return None
        return Food(
            food_id=row['food_id'],
            user_id=row['user_id'],
            date=row['date'],
            meal_type=row['meal_type'],
            description=row.get('description'),
        )
