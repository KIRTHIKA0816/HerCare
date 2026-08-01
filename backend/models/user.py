class User:
    def __init__(self, user_id, name, email, password, age=None,
                 height=None, weight=None, created_date=None):
        self.user_id = user_id
        self.name = name
        self.email = email
        self.password = password
        self.age = age
        self.height = height
        self.weight = weight
        self.created_date = created_date

    def to_dict(self, include_password=False):
        data = {
            'user_id': self.user_id,
            'name': self.name,
            'email': self.email,
            'age': self.age,
            'height': self.height,
            'weight': self.weight,
            'created_date': str(self.created_date) if self.created_date else None,
        }
        if include_password:
            data['password'] = self.password
        return data

    @staticmethod
    def from_row(row):
        if row is None:
            return None
        return User(
            user_id=row['user_id'],
            name=row['name'],
            email=row['email'],
            password=row['password'],
            age=row.get('age'),
            height=row.get('height'),
            weight=row.get('weight'),
            created_date=row.get('created_date'),
        )
