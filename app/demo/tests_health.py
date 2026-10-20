from unittest import mock

from django.db import OperationalError, connection
from django.test import TestCase


class HealthTests(TestCase):
    def test_live_returns_200(self):
        response = self.client.get('/health/live')
        self.assertEqual(response.status_code, 200)

    def test_ready_returns_200_when_database_is_migrated(self):
        response = self.client.get('/health/ready')
        self.assertEqual(response.status_code, 200)

    def test_ready_returns_503_when_migrations_are_pending(self):
        with mock.patch('demo.health.MigrationExecutor') as executor:
            executor.return_value.migration_plan.return_value = [('api', False)]
            response = self.client.get('/health/ready')
        self.assertEqual(response.status_code, 503)
        self.assertEqual(response.json()['reason'], 'pending_migrations')

    def test_ready_returns_503_when_database_is_down(self):
        with mock.patch.object(connection, 'ensure_connection', side_effect=OperationalError('down')):
            response = self.client.get('/health/ready')
        self.assertEqual(response.status_code, 503)
        self.assertEqual(response.json()['reason'], 'database')
