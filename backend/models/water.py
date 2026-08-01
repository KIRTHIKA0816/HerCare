class WaterLog:
    def __init__(self, water_id, user_id, date, glasses=0, goal=8):
        self.water_id = water_id
        self.user_id = user_id
        self.date = date
        self.glasses = glasses
        self.goal = goal

    def to_dict(self):
        return {
            'water_id': self.water_id,
            'user_id': self.user_id,
            'date': str(self.date) if self.date else None,
            'glasses': self.glasses,
            'goal': self.goal,
        }

    @staticmethod
    def from_row(row):
        if row is None:
            return None
        return WaterLog(
            water_id=row['water_id'],
            user_id=row['user_id'],
            date=row['date'],
            glasses=row.get('glasses', 0),
            goal=row.get('goal', 8),
        )
