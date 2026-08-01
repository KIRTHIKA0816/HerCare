class Reminder:
    def __init__(self, reminder_id, user_id, reminder_type, reminder_date,
                 status='Pending'):
        self.reminder_id = reminder_id
        self.user_id = user_id
        self.reminder_type = reminder_type
        self.reminder_date = reminder_date
        self.status = status

    def to_dict(self):
        return {
            'reminder_id': self.reminder_id,
            'user_id': self.user_id,
            'reminder_type': self.reminder_type,
            'reminder_date': str(self.reminder_date) if self.reminder_date else None,
            'status': self.status,
        }

    @staticmethod
    def from_row(row):
        if row is None:
            return None
        return Reminder(
            reminder_id=row['reminder_id'],
            user_id=row['user_id'],
            reminder_type=row['reminder_type'],
            reminder_date=row['reminder_date'],
            status=row.get('status', 'Pending'),
        )
