class Period:
    def __init__(self, period_id, user_id, start_date, end_date=None,
                 cycle_length=28, flow_level='Medium'):
        self.period_id = period_id
        self.user_id = user_id
        self.start_date = start_date
        self.end_date = end_date
        self.cycle_length = cycle_length
        self.flow_level = flow_level

    def to_dict(self):
        return {
            'period_id': self.period_id,
            'user_id': self.user_id,
            'start_date': str(self.start_date) if self.start_date else None,
            'end_date': str(self.end_date) if self.end_date else None,
            'cycle_length': self.cycle_length,
            'flow_level': self.flow_level,
        }

    @staticmethod
    def from_row(row):
        if row is None:
            return None
        return Period(
            period_id=row['period_id'],
            user_id=row['user_id'],
            start_date=row['start_date'],
            end_date=row.get('end_date'),
            cycle_length=row.get('cycle_length', 28),
            flow_level=row.get('flow_level', 'Medium'),
        )
