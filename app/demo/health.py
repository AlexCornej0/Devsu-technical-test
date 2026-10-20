from django.db import DatabaseError, connection
from django.db.migrations.executor import MigrationExecutor
from django.http import JsonResponse
from django.views.decorators.http import require_GET


@require_GET
def live(request):
    """Liveness: the process answers. Never touches the database."""
    return JsonResponse({"status": "ok"})


@require_GET
def ready(request):
    """Readiness: the database is reachable and has no pending migrations."""
    try:
        connection.ensure_connection()
        executor = MigrationExecutor(connection)
        pending = executor.migration_plan(executor.loader.graph.leaf_nodes())
    except DatabaseError:
        return JsonResponse({"status": "unavailable", "reason": "database"}, status=503)
    if pending:
        body = {"status": "unavailable", "reason": "pending_migrations", "count": len(pending)}
        return JsonResponse(body, status=503)
    return JsonResponse({"status": "ok"})
