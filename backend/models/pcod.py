class PCOD:
    def __init__(self, pcod_id, user_id, date, weight_change=None,
                 sleep_hours=None, stress_level=None, exercise_done=False,
                 water_intake=None):
        self.pcod_id = pcod_id
        self.user_id = user_id
        self.date = date
        self.weight_change = weight_change
        self.sleep_hours = sleep_hours
        self.stress_level = stress_level
        self.exercise_done = exercise_done
        self.water_intake = water_intake

    def to_dict(self):
        return {
            'pcod_id': self.pcod_id,
            'user_id': self.user_id,
            'date': str(self.date) if self.date else None,
            'weight_change': self.weight_change,
            'sleep_hours': self.sleep_hours,
            'stress_level': self.stress_level,
            'exercise_done': bool(self.exercise_done),
            'water_intake': self.water_intake,
        }

    @staticmethod
    def from_row(row):
        if row is None:
            return None
        return PCOD(
            pcod_id=row['pcod_id'],
            user_id=row['user_id'],
            date=row['date'],
            weight_change=row.get('weight_change'),
            sleep_hours=row.get('sleep_hours'),
            stress_level=row.get('stress_level'),
            exercise_done=row.get('exercise_done', False),
            water_intake=row.get('water_intake'),
        )
