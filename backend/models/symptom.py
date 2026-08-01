class Symptom:
    def __init__(self, symptom_id, user_id, date, pain_level=None, mood=None,
                 acne=False, hair_fall=False, cramps=False, notes=None):
        self.symptom_id = symptom_id
        self.user_id = user_id
        self.date = date
        self.pain_level = pain_level
        self.mood = mood
        self.acne = acne
        self.hair_fall = hair_fall
        self.cramps = cramps
        self.notes = notes

    def to_dict(self):
        return {
            'symptom_id': self.symptom_id,
            'user_id': self.user_id,
            'date': str(self.date) if self.date else None,
            'pain_level': self.pain_level,
            'mood': self.mood,
            'acne': bool(self.acne),
            'hair_fall': bool(self.hair_fall),
            'cramps': bool(self.cramps),
            'notes': self.notes,
        }

    @staticmethod
    def from_row(row):
        if row is None:
            return None
        return Symptom(
            symptom_id=row['symptom_id'],
            user_id=row['user_id'],
            date=row['date'],
            pain_level=row.get('pain_level'),
            mood=row.get('mood'),
            acne=row.get('acne', False),
            hair_fall=row.get('hair_fall', False),
            cramps=row.get('cramps', False),
            notes=row.get('notes'),
        )
