--
-- PostgreSQL database dump
--

\restrict oVCnw5N9dmLrux6wLfVCNX5JqTGSoRhpVETPKT97muw9mAm0dYfvBjoWQIvrFbG

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA auth;


--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;


--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql;


--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql_public;


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgbouncer;


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA realtime;


--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA vault;


--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: wrappers; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS wrappers WITH SCHEMA extensions;


--
-- Name: EXTENSION wrappers; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION wrappers IS 'Foreign data wrappers developed by Supabase';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


--
-- Name: task_priority; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.task_priority AS ENUM (
    'low',
    'medium',
    'high'
);


--
-- Name: task_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.task_status AS ENUM (
    'todo',
    'inProgress',
    'awaitFeedback',
    'done'
);


--
-- Name: action; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: -
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: -
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  INSERT INTO public.profiles (id, email, display_name, created_at)
  VALUES (
    NEW.id, 
    NEW.email, 
    COALESCE(NEW.raw_user_meta_data->>'display_name', ''),
    NOW()
  );
  RETURN NEW;
EXCEPTION WHEN OTHERS THEN
  -- Ignoră erori pentru a nu bloca crearea userului
  RETURN NEW;
END;
$$;


--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_
        -- Filter by action early - only get subscriptions interested in this action
        -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
        and (subs.action_filter = '*' or subs.action_filter = action::text);

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: -
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contacts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid DEFAULT auth.uid(),
    name text,
    email text,
    phone text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    email text,
    display_name text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: project_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_members (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid,
    user_id uuid,
    role text DEFAULT 'member'::text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    description text,
    owner_id uuid,
    is_guest_project boolean DEFAULT false,
    guest_token text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: task_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task_comments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    task_id uuid,
    author_id uuid,
    guest_token text,
    body text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    project_id uuid,
    title text NOT NULL,
    description text,
    status public.task_status DEFAULT 'todo'::public.task_status,
    priority public.task_priority DEFAULT 'medium'::public.task_priority,
    created_by uuid DEFAULT auth.uid(),
    guest_token text,
    due_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    assignees jsonb DEFAULT '[]'::jsonb,
    subtasks jsonb,
    type text DEFAULT 'Technical Task'::text,
    "position" integer DEFAULT 0,
    CONSTRAINT tasks_type_check CHECK ((type = ANY (ARRAY['User Story'::text, 'Technical Task'::text])))
);


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: -
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: objects; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
b6ccc057-3ea9-4e5f-89b0-d28e37acb208	b6ccc057-3ea9-4e5f-89b0-d28e37acb208	{"sub": "b6ccc057-3ea9-4e5f-89b0-d28e37acb208", "email": "vadykdeejay@gmail.comqweq", "display_name": "vadim cebanu", "email_verified": false, "phone_verified": false}	email	2026-03-06 16:05:08.981532+00	2026-03-06 16:05:08.981578+00	2026-03-06 16:05:08.981578+00	4240d5b1-0a49-4eab-b424-fe151ff85e62
560902da-285b-493c-8d46-16be17996519	560902da-285b-493c-8d46-16be17996519	{"sub": "560902da-285b-493c-8d46-16be17996519", "email": "info@vadimcebanu.dev", "email_verified": false, "phone_verified": false}	email	2026-02-16 09:24:00.080983+00	2026-02-16 09:24:00.081036+00	2026-02-16 09:24:00.081036+00	4e8c6a46-b558-49db-8935-502355105471
c4ec5e93-766d-48c2-8312-8c673287fbd9	c4ec5e93-766d-48c2-8312-8c673287fbd9	{"sub": "c4ec5e93-766d-48c2-8312-8c673287fbd9", "email": "za.gr@web.de", "email_verified": false, "phone_verified": false}	email	2026-02-16 09:26:13.213943+00	2026-02-16 09:26:13.213995+00	2026-02-16 09:26:13.213995+00	833fba82-6274-4d61-aaeb-ce533fa9fdd8
d071f9b2-ce73-44a2-b015-2a2d8efe1503	d071f9b2-ce73-44a2-b015-2a2d8efe1503	{"sub": "d071f9b2-ce73-44a2-b015-2a2d8efe1503", "email": "b.blarr@gmx.de", "email_verified": false, "phone_verified": false}	email	2026-02-16 09:26:42.112345+00	2026-02-16 09:26:42.112394+00	2026-02-16 09:26:42.112394+00	bafbf22b-8893-4c0b-98d6-e677edd5cb5c
05e11232-a2be-4a94-aa31-fe8bbdfa9b23	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	{"sub": "05e11232-a2be-4a94-aa31-fe8bbdfa9b23", "email": "serhatozcakir35@gmail.com", "email_verified": false, "phone_verified": false}	email	2026-02-16 09:27:03.158197+00	2026-02-16 09:27:03.158246+00	2026-02-16 09:27:03.158246+00	c1ed50cf-37ea-453c-a934-af5e6ed26707
51dce4a8-bb3f-44ac-a264-b3837f289ead	51dce4a8-bb3f-44ac-a264-b3837f289ead	{"sub": "51dce4a8-bb3f-44ac-a264-b3837f289ead", "email": "user@gmx.com", "email_verified": false, "phone_verified": false}	email	2026-02-16 10:50:02.727056+00	2026-02-16 10:50:02.727109+00	2026-02-16 10:50:02.727109+00	310c3cd8-7b14-4778-88d7-b014e50513ff
b39d5058-550b-4640-b1c8-a821160cb061	b39d5058-550b-4640-b1c8-a821160cb061	{"sub": "b39d5058-550b-4640-b1c8-a821160cb061", "email": "newuser@mail.com", "email_verified": false, "phone_verified": false}	email	2026-02-16 10:55:55.282374+00	2026-02-16 10:55:55.282422+00	2026-02-16 10:55:55.282422+00	fd3d9011-17d6-4faa-bfa3-ce1c8d55c9e3
306b5d39-a4ee-4848-a64a-01ad4ffa241d	306b5d39-a4ee-4848-a64a-01ad4ffa241d	{"sub": "306b5d39-a4ee-4848-a64a-01ad4ffa241d", "email": "giuliano@da.de", "email_verified": false, "phone_verified": false}	email	2026-02-16 10:57:09.50903+00	2026-02-16 10:57:09.509077+00	2026-02-16 10:57:09.509077+00	6b828ab1-c68e-46fc-b381-4c417b508c19
2bb9bfb9-e2ac-41e9-9c2f-fbfa2c928de5	2bb9bfb9-e2ac-41e9-9c2f-fbfa2c928de5	{"sub": "2bb9bfb9-e2ac-41e9-9c2f-fbfa2c928de5", "email": "uasea@mail.de", "display_name": "vadim cebanu", "email_verified": false, "phone_verified": false}	email	2026-02-17 11:00:46.387716+00	2026-02-17 11:00:46.387774+00	2026-02-17 11:00:46.387774+00	f6444829-2a39-4de0-b368-388dbae6f721
9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	{"sub": "9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1", "email": "vadykdeejay@gmail.com", "display_name": "vadim cebanu", "email_verified": false, "phone_verified": false}	email	2026-02-17 11:02:29.341981+00	2026-02-17 11:02:29.344566+00	2026-02-17 11:02:29.344566+00	970a9064-2af8-40fb-927e-a13c5eae39b8
86c1d4b2-d9b8-4972-880c-9a8d3220d1d1	86c1d4b2-d9b8-4972-880c-9a8d3220d1d1	{"sub": "86c1d4b2-d9b8-4972-880c-9a8d3220d1d1", "email": "test@gmail.com", "display_name": "ser", "email_verified": false, "phone_verified": false}	email	2026-02-17 14:23:29.832226+00	2026-02-17 14:23:29.832284+00	2026-02-17 14:23:29.832284+00	d9f1cec3-ef3e-4254-8f20-1259020bb757
312fbd38-46b4-4611-bf01-ea5b58854967	312fbd38-46b4-4611-bf01-ea5b58854967	{"sub": "312fbd38-46b4-4611-bf01-ea5b58854967", "email": "vadykdeejay@mail.com", "display_name": "vadim cebanu", "email_verified": false, "phone_verified": false}	email	2026-02-17 14:25:19.776058+00	2026-02-17 14:25:19.776105+00	2026-02-17 14:25:19.776105+00	14023ae2-d79e-4221-828a-52457ddd882a
a1d1c5fa-e722-4251-907c-afd134b085df	a1d1c5fa-e722-4251-907c-afd134b085df	{"sub": "a1d1c5fa-e722-4251-907c-afd134b085df", "email": "b.blarr@dmx.de", "display_name": "Benjamin Blaar", "email_verified": false, "phone_verified": false}	email	2026-02-17 16:46:30.305287+00	2026-02-17 16:46:30.305334+00	2026-02-17 16:46:30.305334+00	b2a9a914-8349-4f97-acdb-07b59a25620a
849e4383-8caf-420f-a13d-4e3393ee4645	849e4383-8caf-420f-a13d-4e3393ee4645	{"sub": "849e4383-8caf-420f-a13d-4e3393ee4645", "email": "klaus@tester.de", "display_name": "klaus", "email_verified": false, "phone_verified": false}	email	2026-03-05 10:10:38.051521+00	2026-03-05 10:10:38.051617+00	2026-03-05 10:10:38.051617+00	c26e6692-2b73-45cf-b00a-418c606d5676
3a846c33-7c2d-4ec2-9fe5-ff4eaa092dcc	3a846c33-7c2d-4ec2-9fe5-ff4eaa092dcc	{"sub": "3a846c33-7c2d-4ec2-9fe5-ff4eaa092dcc", "email": "vadim@mail.de", "display_name": "vadim cebanu", "email_verified": false, "phone_verified": false}	email	2026-03-05 19:05:52.823855+00	2026-03-05 19:05:52.823904+00	2026-03-05 19:05:52.823904+00	d78ca562-5da1-4818-a76a-4bd48c3515be
21f90788-2d49-4547-b867-d52455e0d56b	21f90788-2d49-4547-b867-d52455e0d56b	{"sub": "21f90788-2d49-4547-b867-d52455e0d56b", "email": "vadim@mail.dee", "display_name": "vadim cebanu", "email_verified": false, "phone_verified": false}	email	2026-03-05 19:09:07.496031+00	2026-03-05 19:09:07.496079+00	2026-03-05 19:09:07.496079+00	7029e5c8-374a-47f9-bdcc-a584e21e0fe0
8642c8b5-f0b9-4811-8f7a-425155de9d1d	8642c8b5-f0b9-4811-8f7a-425155de9d1d	{"sub": "8642c8b5-f0b9-4811-8f7a-425155de9d1d", "email": "vadim@gmail.de", "display_name": "vadim cebanu", "email_verified": false, "phone_verified": false}	email	2026-03-05 19:12:42.330365+00	2026-03-05 19:12:42.33041+00	2026-03-05 19:12:42.33041+00	811a20f0-72da-45c1-9b66-72be8e636d1b
3f062642-a3ec-45c2-be36-4b05fe0b5235	3f062642-a3ec-45c2-be36-4b05fe0b5235	{"sub": "3f062642-a3ec-45c2-be36-4b05fe0b5235", "email": "vadim34@mail.de", "display_name": "vadim cebanu", "email_verified": false, "phone_verified": false}	email	2026-03-05 19:13:18.454638+00	2026-03-05 19:13:18.45468+00	2026-03-05 19:13:18.45468+00	a12bc161-4958-48d5-9b4e-8755bc9705c4
da0ff70f-fb32-418b-b84f-f66d7fcf6685	da0ff70f-fb32-418b-b84f-f66d7fcf6685	{"sub": "da0ff70f-fb32-418b-b84f-f66d7fcf6685", "email": "vadykdeejay@gmail.comwer", "display_name": "vadim cebanu", "email_verified": false, "phone_verified": false}	email	2026-03-06 16:03:28.21172+00	2026-03-06 16:03:28.211786+00	2026-03-06 16:03:28.211786+00	7a255270-d1de-4309-838c-6e482f4926de
14c5bf86-010f-4355-b352-200ddc0c4aee	14c5bf86-010f-4355-b352-200ddc0c4aee	{"sub": "14c5bf86-010f-4355-b352-200ddc0c4aee", "email": "meyer@mail.de", "display_name": "Peter Meyer", "email_verified": false, "phone_verified": false}	email	2026-03-07 07:42:51.910527+00	2026-03-07 07:42:51.910581+00	2026-03-07 07:42:51.910581+00	9cc250cf-e0e1-4a39-9a24-78a623dd5cee
924c7e03-fc42-479c-b841-c7eaa607cdc6	924c7e03-fc42-479c-b841-c7eaa607cdc6	{"sub": "924c7e03-fc42-479c-b841-c7eaa607cdc6", "email": "zar.gr@web.de", "display_name": "Gregor Zar", "email_verified": false, "phone_verified": false}	email	2026-03-09 08:09:54.07944+00	2026-03-09 08:09:54.0795+00	2026-03-09 08:09:54.0795+00	de45bd72-6db5-4050-94af-0b1065cef583
993dc109-8d6c-4369-8011-8b39b0059830	993dc109-8d6c-4369-8011-8b39b0059830	{"sub": "993dc109-8d6c-4369-8011-8b39b0059830", "email": "vadyk@mail.com", "display_name": "vadim cebanu", "email_verified": false, "phone_verified": false}	email	2026-03-09 09:01:18.203276+00	2026-03-09 09:01:18.203327+00	2026-03-09 09:01:18.203327+00	2c658e64-a5e9-47b6-9ca4-57c4cfcf68af
092175d3-fa6b-4b6d-9a62-67a547151b5c	092175d3-fa6b-4b6d-9a62-67a547151b5c	{"sub": "092175d3-fa6b-4b6d-9a62-67a547151b5c", "email": "uaseea@mgail.de", "display_name": "uasea", "email_verified": false, "phone_verified": false}	email	2026-03-09 10:23:51.709359+00	2026-03-09 10:23:51.70999+00	2026-03-09 10:23:51.70999+00	51d472ab-f1ab-4bad-be2d-a3883ab7de6e
73ebb754-d8b0-46d2-bea9-846fa82d3657	73ebb754-d8b0-46d2-bea9-846fa82d3657	{"sub": "73ebb754-d8b0-46d2-bea9-846fa82d3657", "email": "alladin@mail.de", "display_name": "alladin", "email_verified": false, "phone_verified": false}	email	2026-03-09 10:25:40.945849+00	2026-03-09 10:25:40.945894+00	2026-03-09 10:25:40.945894+00	22b5bf08-9bf6-4b6b-8391-ec8276407519
b0187f61-fe65-436d-a9f8-dc1a2b4d307e	b0187f61-fe65-436d-a9f8-dc1a2b4d307e	{"sub": "b0187f61-fe65-436d-a9f8-dc1a2b4d307e", "email": "mario@mail.de", "display_name": "mario", "email_verified": false, "phone_verified": false}	email	2026-03-09 10:27:30.557573+00	2026-03-09 10:27:30.557623+00	2026-03-09 10:27:30.557623+00	4221b54c-3895-4785-88c5-66922e9721b4
1c0f7c19-3851-4429-91c9-6b8d67d4e7b7	1c0f7c19-3851-4429-91c9-6b8d67d4e7b7	{"sub": "1c0f7c19-3851-4429-91c9-6b8d67d4e7b7", "email": "marrio@mgail.de", "display_name": "marrio", "email_verified": false, "phone_verified": false}	email	2026-03-09 10:32:02.813624+00	2026-03-09 10:32:02.813669+00	2026-03-09 10:32:02.813669+00	bfe747f0-d99e-44d3-b903-c29bd8cb75c5
bcefc261-a2e7-4936-80c7-ff01bf33cb38	bcefc261-a2e7-4936-80c7-ff01bf33cb38	{"sub": "bcefc261-a2e7-4936-80c7-ff01bf33cb38", "email": "aladinnn@mail.de", "display_name": "alladin", "email_verified": false, "phone_verified": false}	email	2026-03-09 10:34:50.973189+00	2026-03-09 10:34:50.973257+00	2026-03-09 10:34:50.973257+00	535dee7e-ebe1-4f4b-95d9-9c08810e6767
22ca59ca-9978-4986-a24b-38251f8e78e2	22ca59ca-9978-4986-a24b-38251f8e78e2	{"sub": "22ca59ca-9978-4986-a24b-38251f8e78e2", "email": "peterm@peter.de", "display_name": "Peter Meyerdfdsfdfsdfsdfdsfsdfdsfsdfsdfsdf", "email_verified": false, "phone_verified": false}	email	2026-03-09 13:46:13.637127+00	2026-03-09 13:46:13.637178+00	2026-03-09 13:46:13.637178+00	59487a0d-41ff-41be-9999-017e5da5c722
217a05cc-7709-4e39-a0cf-ede8b02d87a4	217a05cc-7709-4e39-a0cf-ede8b02d87a4	{"sub": "217a05cc-7709-4e39-a0cf-ede8b02d87a4", "email": "12@1.de", "display_name": "A", "email_verified": false, "phone_verified": false}	email	2026-03-09 13:48:09.283921+00	2026-03-09 13:48:09.28398+00	2026-03-09 13:48:09.28398+00	6fcef564-0a42-4ec0-94ef-b3f063b22927
75f39917-51d9-4aa7-bdc6-7466cd70daf0	75f39917-51d9-4aa7-bdc6-7466cd70daf0	{"sub": "75f39917-51d9-4aa7-bdc6-7466cd70daf0", "email": "111111111111111111111111111111111111111111111111111112@1.de", "display_name": "111111111111111111111111111111111111111111111111111111111111111111111111111", "email_verified": false, "phone_verified": false}	email	2026-03-09 13:50:27.388483+00	2026-03-09 13:50:27.388528+00	2026-03-09 13:50:27.388528+00	2113255e-2cf2-4ddc-985d-d914bd7e987d
0934afbd-f66b-4497-b251-4dbab6283576	0934afbd-f66b-4497-b251-4dbab6283576	{"sub": "0934afbd-f66b-4497-b251-4dbab6283576", "email": "klaus@tester2.de", "display_name": "KlausDerZweite", "email_verified": false, "phone_verified": false}	email	2026-03-10 15:02:52.305373+00	2026-03-10 15:02:52.305432+00	2026-03-10 15:02:52.305432+00	8ab993da-7131-4fdb-842d-ca28b99a2744
fdaf6d5b-b6de-4dcb-bcb5-fbf0276736bf	fdaf6d5b-b6de-4dcb-bcb5-fbf0276736bf	{"sub": "fdaf6d5b-b6de-4dcb-bcb5-fbf0276736bf", "email": "klausderzwoelfte@web.de", "display_name": "klausder zwölfte", "email_verified": false, "phone_verified": false}	email	2026-03-10 15:21:08.322503+00	2026-03-10 15:21:08.322552+00	2026-03-10 15:21:08.322552+00	0ac62013-60ba-4a56-865a-0fea562c2913
ff94c710-a33a-498c-a6a6-6ce84f1977fc	ff94c710-a33a-498c-a6a6-6ce84f1977fc	{"sub": "ff94c710-a33a-498c-a6a6-6ce84f1977fc", "email": "mario@web.de", "display_name": "mario", "email_verified": false, "phone_verified": false}	email	2026-03-10 15:45:09.487333+00	2026-03-10 15:45:09.487392+00	2026-03-10 15:45:09.487392+00	23072663-e8a5-4784-9823-d956c1990293
c14fea5b-d484-4c2f-b022-c5ed8a34a2c1	c14fea5b-d484-4c2f-b022-c5ed8a34a2c1	{"sub": "c14fea5b-d484-4c2f-b022-c5ed8a34a2c1", "email": "alladin@web.de", "display_name": "alladin", "email_verified": false, "phone_verified": false}	email	2026-03-10 15:59:29.629151+00	2026-03-10 15:59:29.629198+00	2026-03-10 15:59:29.629198+00	f5cc54f2-85d2-488e-b307-585536547dfd
9647ef90-fd59-4dde-8a76-26668af98700	9647ef90-fd59-4dde-8a76-26668af98700	{"sub": "9647ef90-fd59-4dde-8a76-26668af98700", "email": "alladdin@web.de", "display_name": "alladin", "email_verified": false, "phone_verified": false}	email	2026-03-10 16:00:11.016576+00	2026-03-10 16:00:11.01662+00	2026-03-10 16:00:11.01662+00	b1c70c8c-d166-44f4-a14f-d6bb277857d0
750436b2-3280-4fc1-88a6-92cdee4b774c	750436b2-3280-4fc1-88a6-92cdee4b774c	{"sub": "750436b2-3280-4fc1-88a6-92cdee4b774c", "email": "hannikohl@web.de", "display_name": "Hannelore Kohl", "email_verified": false, "phone_verified": false}	email	2026-03-11 08:14:59.009088+00	2026-03-11 08:14:59.009141+00	2026-03-11 08:14:59.009141+00	43c1ef5e-5edd-4d53-a0b6-18fe023f9b61
abc33f51-f7fe-45aa-ba58-71be49d0cf4f	abc33f51-f7fe-45aa-ba58-71be49d0cf4f	{"sub": "abc33f51-f7fe-45aa-ba58-71be49d0cf4f", "email": "klausi@web.de", "display_name": "klausi", "email_verified": false, "phone_verified": false}	email	2026-03-11 09:27:36.523283+00	2026-03-11 09:27:36.523344+00	2026-03-11 09:27:36.523344+00	dd6355c5-eb9a-4c40-aecd-95ad15585224
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
b5aa6c9e-d6d2-40e1-bfd1-fbcbb1fdbf31	2026-03-09 09:01:18.298675+00	2026-03-09 09:01:18.298675+00	password	2462881e-94fd-45d4-977e-fce2c274ad4a
ba84d120-f4fd-437e-b391-2de5c6286f0c	2026-02-16 14:44:58.396138+00	2026-02-16 14:44:58.396138+00	password	2ae87f74-7301-4ad8-aac2-e68e6160e17d
fe5c6b89-8d21-4592-92b7-b12dbbd98e19	2026-02-16 18:05:19.278828+00	2026-02-16 18:05:19.278828+00	anonymous	6ac1025a-b674-4a44-b67a-92b7b16adca9
d9cdd500-4426-4a65-ae40-7ecab1610bca	2026-02-16 18:06:02.244401+00	2026-02-16 18:06:02.244401+00	anonymous	739af827-7e9b-4ee2-bece-852274a11307
0b9dae88-1c2b-46fd-afae-d74735be41dd	2026-02-16 19:02:59.413784+00	2026-02-16 19:02:59.413784+00	anonymous	10b005be-2cf9-4e34-b7b4-3f6cece6d20b
95738a33-c019-4ac7-9877-0b7b4d73bf00	2026-02-16 19:04:05.942855+00	2026-02-16 19:04:05.942855+00	anonymous	3fa201a0-53c1-45bb-bcfc-6c1c53cfb85e
200fe79a-3d32-494b-a650-5fb95fe1bc50	2026-02-17 08:30:14.398979+00	2026-02-17 08:30:14.398979+00	anonymous	a10ec31a-6c87-4750-94a9-1d90e615978a
b64f9be4-2fa0-4d5b-b7c7-db97945c1b1c	2026-02-17 11:47:52.902319+00	2026-02-17 11:47:52.902319+00	password	f6a0a4b5-7aeb-42b2-abaf-927e0eec5654
fb798671-07e5-408f-9628-f8899062efb3	2026-02-17 12:59:22.883262+00	2026-02-17 12:59:22.883262+00	password	55a0d141-f415-4a74-b21b-68cc7924d4f4
db50e822-dc01-4f52-95ff-beb029e29386	2026-02-17 13:00:23.914066+00	2026-02-17 13:00:23.914066+00	password	c8c63363-5f82-48e8-a6d5-ef6d36306a52
84a8567a-0cf7-4e75-8c83-f02a25b091ad	2026-02-17 13:02:12.891089+00	2026-02-17 13:02:12.891089+00	password	1fbb56dd-1afc-44d5-a6c1-d45ad9c30ee3
79a47e5c-dcaa-443d-9743-7590959daf1f	2026-02-17 13:03:59.952824+00	2026-02-17 13:03:59.952824+00	password	e9ff4e7d-e530-4fe8-8c76-870df3de8ba2
fdb73807-cbb2-45db-a8c0-e28be3c8fca8	2026-02-17 13:05:03.990874+00	2026-02-17 13:05:03.990874+00	password	17484e34-f9ea-4a18-b859-2f24fc1bf2d7
7ce1fdaf-4a81-4e72-a29e-5b279ba0d0d1	2026-02-17 13:05:08.771411+00	2026-02-17 13:05:08.771411+00	password	3292554e-af6d-4335-ba83-4fc3e8c35c85
5f5fcd62-060d-498b-a0c4-cf959578ed0e	2026-02-17 13:06:50.123611+00	2026-02-17 13:06:50.123611+00	password	2a020773-ccdb-4451-895c-f42a0094081c
e12199cd-6b8e-43f6-bf83-a23c0b1163e0	2026-02-17 13:14:07.738171+00	2026-02-17 13:14:07.738171+00	password	633aeabe-5bbc-45f7-b175-8ad3abc111ef
2775d9f0-f93e-4f89-be9d-187ba88836f9	2026-02-17 13:39:46.239804+00	2026-02-17 13:39:46.239804+00	password	19453770-1a6f-46cc-8bb4-2ac22c32ace8
41662b58-18d5-406e-b68c-f39a28e1a022	2026-02-17 14:00:03.622993+00	2026-02-17 14:00:03.622993+00	password	4a38a074-3aa2-4848-8837-6c09c5b99f1f
890751a4-5d95-4c37-a28d-40c8af6cf6e3	2026-02-17 14:00:33.557051+00	2026-02-17 14:00:33.557051+00	password	082cdd70-7ad5-4f99-a3eb-ac76ebdedd19
2e8c68ff-d5d2-45f1-b5bc-a658f4a09711	2026-02-17 14:00:37.577809+00	2026-02-17 14:00:37.577809+00	password	b5062b58-939d-4c66-ac09-f46e9e77b382
59b912ee-7ee4-4086-bbca-ec38bd7e35d0	2026-02-17 14:01:25.503569+00	2026-02-17 14:01:25.503569+00	password	fa23f127-65d0-4712-98f3-2fe995fecf49
0a93fd1e-3b17-4ca7-be1a-5a4aeb0338c0	2026-02-17 14:02:31.248432+00	2026-02-17 14:02:31.248432+00	password	be2cfc15-993e-48b6-b28b-8c0fa5d03f59
bac69b22-b81d-4391-beae-2641151c7e64	2026-02-17 14:02:49.686769+00	2026-02-17 14:02:49.686769+00	password	b7c1033e-2eb0-456b-b47b-727835b2ae97
9be04c45-692e-4eec-8bd5-1d2a905006d7	2026-02-17 14:03:15.592686+00	2026-02-17 14:03:15.592686+00	password	bb3391cd-dfdf-40b7-a5ba-4cbb448a54a8
ebb842f9-ce26-4226-8e02-94262484b4e0	2026-02-17 14:04:00.738815+00	2026-02-17 14:04:00.738815+00	password	3995c85b-24a8-4f31-9c3b-834b5df237e1
30e1867a-a5f3-403d-a322-02e78015d89f	2026-02-17 14:04:20.211181+00	2026-02-17 14:04:20.211181+00	password	e4b27093-d6b5-49b5-a26d-54b0b8e761c2
7e6adb9a-b376-4b10-b061-e22a3b32feb4	2026-02-17 14:05:27.345979+00	2026-02-17 14:05:27.345979+00	password	731218cc-22cc-482b-94c0-e7b65e3d8745
2c1bb0b7-5b1d-4bbf-a879-4380a070e555	2026-02-17 14:05:37.60647+00	2026-02-17 14:05:37.60647+00	password	5cfe5035-e171-4925-83b0-2c4be4097201
7f1758a0-617c-494b-beb3-c99e2c86817c	2026-02-17 14:06:49.841648+00	2026-02-17 14:06:49.841648+00	password	9ef1eae0-9d6a-4e6b-ad83-05c2430a9313
25c2e177-3b97-4c31-9c0b-ef7bfa223b39	2026-02-17 14:08:22.938639+00	2026-02-17 14:08:22.938639+00	password	e1646dc5-5938-4158-b5d1-6a4872a79a54
35c7f1de-31b9-4a4e-a76c-c891d633180f	2026-02-17 14:10:06.575969+00	2026-02-17 14:10:06.575969+00	password	2dc95f50-5546-4796-b67f-c5f25c974970
3256efed-2514-49a3-9e8b-55b55c4b3826	2026-02-17 14:12:16.812184+00	2026-02-17 14:12:16.812184+00	password	bb8fca05-c6b0-46aa-b2d7-f39421d15966
94ea9f8d-e09e-4ddb-ba75-bb37ba8416a4	2026-02-17 14:14:13.66861+00	2026-02-17 14:14:13.66861+00	password	f0c01d37-ccb2-4811-9e13-171688801303
499b0b19-fc82-437e-8bd0-47b9ed36df9a	2026-02-17 14:19:15.821989+00	2026-02-17 14:19:15.821989+00	password	965e23a7-37f6-439d-ba84-b67dbdf9b264
81ac6413-11a1-4430-a035-c4bb4a3451cd	2026-02-17 14:22:15.488397+00	2026-02-17 14:22:15.488397+00	password	c02248a2-49a8-41bd-9a4e-4ee4dbb89d93
29944caf-1aa9-416c-be71-5a33f6a8490e	2026-02-17 14:23:29.847825+00	2026-02-17 14:23:29.847825+00	password	abbcb482-f1f5-4e84-9581-d75b0fb80e43
d06e7ef5-0cf3-4314-8702-1fb775b7e857	2026-02-17 14:23:44.648642+00	2026-02-17 14:23:44.648642+00	password	0019b589-3fa5-46d7-9a3f-bb89d5ed7a2f
83390bb2-9482-419b-aff5-1b747f57e9fa	2026-02-17 14:25:19.796439+00	2026-02-17 14:25:19.796439+00	password	24a7a546-0ec8-4f45-a95f-9a79568a28e7
00ec2db2-5612-4fe5-b679-42f485fb1a80	2026-02-17 14:31:24.446486+00	2026-02-17 14:31:24.446486+00	password	0fc685d2-b79e-42c8-8e7b-d78f9b869063
bb6c0eae-ae89-426c-9419-4cf74def72f1	2026-02-17 14:31:53.919017+00	2026-02-17 14:31:53.919017+00	password	676a6224-07b9-4aaa-83be-5392d4a7e8d7
12e61b4b-d4a7-44e7-98e1-5699626a9eed	2026-02-17 14:38:57.108407+00	2026-02-17 14:38:57.108407+00	password	1aa88cc0-e65d-4dcb-b420-288ccc7d57aa
763254bb-c2aa-49a7-800a-53e670a85ac3	2026-02-17 14:39:21.281662+00	2026-02-17 14:39:21.281662+00	password	e67455fa-aa0f-4bbf-80e1-ed9a8c16bc6c
18e99fae-79cc-4948-bb55-fc4e875776e3	2026-02-17 14:39:40.475033+00	2026-02-17 14:39:40.475033+00	password	1201c320-83b9-4d40-9c87-7f24ef5cb90a
3af17e5e-a1e9-458f-b009-aa57f1a995ff	2026-02-17 14:41:22.884102+00	2026-02-17 14:41:22.884102+00	password	897ba03a-e243-4179-88ee-d759e2d8887e
12a538c9-838d-40eb-9f82-ce3ddbaeead4	2026-02-17 14:41:44.127204+00	2026-02-17 14:41:44.127204+00	password	4286d5fe-31a5-40c2-9630-186b219fb3db
55461262-cf41-4cdf-b2b0-02946a87b74c	2026-02-17 15:34:47.950673+00	2026-02-17 15:34:47.950673+00	password	a6e3796a-67ea-42b0-b1a5-75644b06c9ce
b73698ca-262b-49e3-89f5-abca6e255bf8	2026-02-17 15:45:12.269455+00	2026-02-17 15:45:12.269455+00	password	978c29fb-0fbc-40ef-b637-b62a320364b4
3f480e29-9bc1-4a0a-ae48-80f93b5955ae	2026-02-17 15:45:29.775867+00	2026-02-17 15:45:29.775867+00	password	1ee98c31-310b-45dd-a759-025bf1fdcd77
d7bbf19c-ca78-4a08-a8a5-36ee95156d3a	2026-02-17 15:54:53.494824+00	2026-02-17 15:54:53.494824+00	password	ec56d27b-40d9-4826-becc-8f25b508f2ab
78cd1562-7867-441e-9df4-f74e6a651f51	2026-02-17 16:37:24.638159+00	2026-02-17 16:37:24.638159+00	password	c9eacc2c-1959-43fd-8850-676ba7adaf1e
6d69da0f-d7b5-42bb-862c-d3849016fec8	2026-02-17 16:37:54.779376+00	2026-02-17 16:37:54.779376+00	password	55183678-563a-4578-98bf-24dbcff73402
0a17f5ce-dd3c-4008-b0ae-5fee1875f52a	2026-02-17 16:38:19.6651+00	2026-02-17 16:38:19.6651+00	password	52cc07d0-e3cb-4cd3-877b-ae1ca2e2c5f1
1854594f-d9b9-41c4-b1e4-65fec4b7ce15	2026-02-17 16:38:31.474444+00	2026-02-17 16:38:31.474444+00	password	aabd0043-360d-4961-b0d4-5d1b06a6e7ee
3d32c47a-d4bf-432c-9119-cb99560ef38d	2026-02-17 16:46:30.32178+00	2026-02-17 16:46:30.32178+00	password	b0068dd0-4427-48d3-8717-1ba4f9bcd626
df825fb5-6320-433e-bdbc-81447e80c041	2026-02-17 16:46:42.411413+00	2026-02-17 16:46:42.411413+00	password	ae3e7126-4732-4e7e-8610-05b6af4df2bb
54cff7fd-f7f3-44d0-ad91-8bfd4cd79708	2026-02-17 16:47:13.153795+00	2026-02-17 16:47:13.153795+00	password	43a8ed41-52fa-4cc7-a863-9dc4bf9ba284
7808b525-3751-4459-9abe-ab37f167a967	2026-02-17 16:57:08.109131+00	2026-02-17 16:57:08.109131+00	password	1ba6d3c1-67d9-4672-b1ed-d02409a720c6
05c44ef7-1679-4e3b-8184-0e848e32dcf8	2026-02-17 16:57:09.591495+00	2026-02-17 16:57:09.591495+00	password	846a93e1-5690-4129-846e-515d112884ae
4d63bee2-24ad-48d7-af90-1b02ac4370cf	2026-02-17 17:28:01.517838+00	2026-02-17 17:28:01.517838+00	password	7a849fe3-1710-426c-a68b-ac52a592c45c
e485928a-a49f-438b-9f1d-354e8eba91aa	2026-02-18 08:10:08.436428+00	2026-02-18 08:10:08.436428+00	password	c20322dd-2f8d-4e46-804f-7c143985c42d
4ab51fe5-a56d-43b7-a376-e3fdb9b1f91a	2026-02-18 08:12:20.573524+00	2026-02-18 08:12:20.573524+00	password	f520c3ec-7f67-41d6-9818-00425f71d9b3
ab835af8-c718-49a0-82ff-d54fd2d3727a	2026-02-18 08:14:02.264631+00	2026-02-18 08:14:02.264631+00	password	69766c5a-1b5f-4ce6-bf5b-c4c0fd8accc1
5a0582f2-27ef-497d-9f8f-d2c202dcf389	2026-02-18 08:17:13.881877+00	2026-02-18 08:17:13.881877+00	password	d44a5785-eb5d-4bcb-a62d-fd529efd6ca5
7ffb102c-41c9-4a1b-94a7-92df379af1df	2026-02-18 09:27:24.335477+00	2026-02-18 09:27:24.335477+00	password	d39c9e22-6027-48e3-b7c8-5cdaefa7d715
d8582c75-1e8d-44ac-8c63-4fdf856c646b	2026-02-18 11:09:18.095094+00	2026-02-18 11:09:18.095094+00	password	e513b6b8-7b64-4bae-a70f-b70ddf623018
f275c52e-f385-43ed-86e2-e988d5b7795d	2026-02-18 11:23:23.614082+00	2026-02-18 11:23:23.614082+00	password	744c4912-f50b-42b1-a289-0fd78bd3fd17
6a4d01e9-cad7-4723-8845-b6466a2174a8	2026-02-18 11:23:41.002696+00	2026-02-18 11:23:41.002696+00	password	e04797c5-8ac7-4d29-b4ec-af792f20b7d7
0846d543-467e-4f12-8347-9260486bf249	2026-02-18 11:26:26.022128+00	2026-02-18 11:26:26.022128+00	password	34baf53f-055c-40f7-9bfe-d268bdf8a1b3
2521feb6-ff7f-48c6-ad67-a59bbdd80ebe	2026-02-18 12:37:46.347163+00	2026-02-18 12:37:46.347163+00	password	1082ca8d-6fab-4a52-bc88-10b7cf370cd1
8324ab27-5e71-4e11-8cc6-243612f2892b	2026-02-18 18:28:59.066238+00	2026-02-18 18:28:59.066238+00	password	7d074f3d-ebc6-45bf-9d81-5809dcbd6837
5b71cd4c-c447-4f04-92be-5afcc9db5d36	2026-02-19 10:12:12.640075+00	2026-02-19 10:12:12.640075+00	password	01a362bd-cdbf-427b-b3db-f5d545a8761a
bbaf75e5-e893-40b9-af88-1feb9d976d12	2026-02-19 12:12:41.865061+00	2026-02-19 12:12:41.865061+00	password	f41e3758-8b1f-4460-a126-83b6404e0b14
01413de3-2563-4c2e-ab2f-7fca2e016dac	2026-02-19 14:26:00.29518+00	2026-02-19 14:26:00.29518+00	password	4d3e4e3d-96be-4235-9563-1b1f87ad51d0
5501bda7-4d4b-4afc-a8b7-0921399db3e9	2026-02-20 10:18:28.996617+00	2026-02-20 10:18:28.996617+00	password	6c9d3395-6e87-4f2f-823d-39ea96ed9ae8
29b13c37-a5d5-4295-b568-73f5b08024dc	2026-02-20 10:55:34.740909+00	2026-02-20 10:55:34.740909+00	password	af25c09c-9bf3-4608-b5df-8df858f1abdc
95570d1b-b072-4ab4-be37-857176670cf9	2026-02-20 10:56:08.497588+00	2026-02-20 10:56:08.497588+00	password	a7892200-31bc-4a53-afd1-40c38c3641f0
05824fe1-98de-4ba1-9b75-4e08d7cac146	2026-02-20 12:33:50.936989+00	2026-02-20 12:33:50.936989+00	password	f14aeee7-e7bc-4a82-8e98-0bbb99da61e8
5c7870be-5b05-4ada-b5a3-b94bfbb75442	2026-02-20 12:38:30.564985+00	2026-02-20 12:38:30.564985+00	password	48850977-326f-423c-9b4f-316d65e4c361
72f67b78-5c73-4add-947a-ae4ccc504d5a	2026-02-20 12:55:33.475245+00	2026-02-20 12:55:33.475245+00	password	ac019014-2ffa-4ca4-9294-6a2a049cf9ce
7957ff95-3335-4487-b9e5-a5553f33b644	2026-02-20 13:01:36.017386+00	2026-02-20 13:01:36.017386+00	password	44030e5e-d5ed-4078-837a-218a8ce1e153
922e9c32-e9ac-4b59-9b1c-faee37586f69	2026-02-20 13:53:12.320169+00	2026-02-20 13:53:12.320169+00	password	929c48e3-6f40-495e-8f53-9642be19168b
f0a9cb41-bd22-41f3-ad47-75d396686025	2026-02-20 15:13:36.028504+00	2026-02-20 15:13:36.028504+00	password	ba788f22-3ea6-4c79-9391-2fb49769bb07
e4f2bcd3-0450-400d-b1de-9b29d0728b66	2026-02-20 15:25:41.56021+00	2026-02-20 15:25:41.56021+00	password	8f449d22-5053-4dd2-b730-bdecc19693bb
344c9d75-8c3b-4f31-80d8-abee28b3826b	2026-02-20 15:35:39.737557+00	2026-02-20 15:35:39.737557+00	password	d7e7db34-31fe-41e4-886e-96715acb15aa
5b8f3689-ea63-4b78-87a7-1954b9511d2c	2026-02-20 15:36:56.669552+00	2026-02-20 15:36:56.669552+00	password	be0252f8-e595-48b9-9856-1d03669a1c15
cc1ccc9a-c570-46a9-b3b8-2404ae2a26f0	2026-02-20 15:37:08.548022+00	2026-02-20 15:37:08.548022+00	password	e39dde65-293b-4528-9d95-1bc7ce820a99
1c4def97-0027-4852-83cd-6a71ffc224af	2026-02-20 15:37:21.563381+00	2026-02-20 15:37:21.563381+00	password	42de9ccd-376d-45d4-a31c-b9ec55b4ece7
ed2bc9ce-96ce-4c37-a9d0-765f91b64780	2026-02-20 15:38:05.148152+00	2026-02-20 15:38:05.148152+00	password	16da317b-36ef-4a9e-8689-9614ebdc07f3
2eacbbb8-8773-410f-ad1a-a708a5e3ef29	2026-02-22 09:50:05.001788+00	2026-02-22 09:50:05.001788+00	password	b4a4dac1-89ff-4db8-9e87-3d8a1858c0e3
e2523bd1-ce69-4dcf-a45d-c4678ddfff29	2026-02-23 18:04:42.648591+00	2026-02-23 18:04:42.648591+00	password	198b643a-655a-492a-a0c0-2ebbcc509b48
8d55a955-6f7f-494f-88e6-7d278675097d	2026-02-23 18:15:27.334184+00	2026-02-23 18:15:27.334184+00	password	e49d3809-0552-4e0c-9698-0d850326743e
57e7fc31-cf70-4613-a2fe-8a7b4e57607f	2026-02-23 18:22:11.895424+00	2026-02-23 18:22:11.895424+00	password	15b8db1b-d18c-44e0-b837-e1c27ec00b08
e112cbc6-dbdb-46ab-aee6-92d6a5cffc18	2026-02-24 07:24:01.875206+00	2026-02-24 07:24:01.875206+00	password	af2d8149-f00c-4387-a0b3-cfe57eb80aef
6761dae3-442b-4a0c-8e78-2613a27fd90e	2026-02-24 17:12:18.629831+00	2026-02-24 17:12:18.629831+00	password	414bf832-1e26-4295-93e4-a1630bd23eff
2edb42f5-9060-4358-8ad0-e9dd8e5e6a8e	2026-02-24 17:18:15.959385+00	2026-02-24 17:18:15.959385+00	password	68af3fd8-0a12-47a3-8b9c-ca3c19818f17
2045ba4a-9cdb-47ac-b162-4f89b71ccacd	2026-02-24 18:31:32.849958+00	2026-02-24 18:31:32.849958+00	password	54348757-8f35-4638-8ea8-e5a11ddbd3f9
b01b150f-a2a0-49db-a81c-682cd6f320fa	2026-02-24 18:37:18.650181+00	2026-02-24 18:37:18.650181+00	password	fafa7cdb-c3c6-40e9-ac40-03d28a7f2276
d470f314-dba7-4cdb-8c32-59e4c59d63d8	2026-02-24 18:37:32.602175+00	2026-02-24 18:37:32.602175+00	password	9deeff36-7e36-49ea-8fdb-b36538147380
aafc6906-34ce-4925-9049-8f82b504da47	2026-02-24 18:41:09.425251+00	2026-02-24 18:41:09.425251+00	password	a2e6cbcc-876c-4b55-9878-2cbcd9cb31ea
67855094-e439-490c-82a2-3b1a60dfa484	2026-02-24 18:57:49.224827+00	2026-02-24 18:57:49.224827+00	password	c7afc79f-e30e-4e86-8cc5-f77b98f9f4eb
1fc95765-74be-4a05-87dc-9d9ef84138b3	2026-02-25 08:09:27.491839+00	2026-02-25 08:09:27.491839+00	password	149ecec5-c9cf-4d01-81e7-44b6b3c6a340
110072b5-f096-4131-b3bf-ce4cb10a007f	2026-02-25 08:13:12.908779+00	2026-02-25 08:13:12.908779+00	password	ce182e87-ebe6-4e3c-b39e-47beaa8331cc
6f000ef3-6fdc-4366-a41a-761ad44db9d6	2026-02-25 08:13:43.069261+00	2026-02-25 08:13:43.069261+00	password	ed164899-7dc5-47a4-86c1-1c49f98211bb
70decc67-f748-4257-8c23-f294ec203927	2026-02-25 08:15:48.726387+00	2026-02-25 08:15:48.726387+00	password	334e9061-8941-4976-8121-c37b6dc4d3bc
64984977-ccd2-48d4-95db-51e916e1c775	2026-02-25 08:17:08.089062+00	2026-02-25 08:17:08.089062+00	password	d146d42c-07a8-4fd1-ab0a-c209bcfa46e5
71744bbf-6091-4e4c-b1f3-7e0261159857	2026-02-25 08:17:23.454707+00	2026-02-25 08:17:23.454707+00	password	ee404062-00e1-44ba-9c80-b7e414d41e7d
7c048b83-087a-4efd-a751-ac714bc7979e	2026-02-25 08:18:54.674621+00	2026-02-25 08:18:54.674621+00	password	8a913b26-f0ed-429e-b34b-4b77106a5705
f032bc4d-e36e-4f8e-bb95-e107cd5f421a	2026-02-25 08:23:46.386449+00	2026-02-25 08:23:46.386449+00	password	0fa05e2f-2eef-44d5-a6d4-3866e95156b3
2046e76d-2c8a-42ff-8b3d-457716c373b1	2026-02-25 21:10:19.118375+00	2026-02-25 21:10:19.118375+00	password	53ce0a27-2707-4f28-b6ce-6680a2ae1124
c49cc55d-fcb6-43dd-b601-492199c658ee	2026-02-25 21:59:35.191124+00	2026-02-25 21:59:35.191124+00	password	a1427cb6-11fa-48b8-b606-b6528e829e3f
b4fdae1e-0386-4c68-a285-d5747b202472	2026-02-25 22:00:26.277361+00	2026-02-25 22:00:26.277361+00	password	9222b6dd-2ba8-47f4-9be1-a49bd33b9028
976500e2-0416-4d6a-9c2f-e0930e762dcb	2026-02-25 22:00:50.973674+00	2026-02-25 22:00:50.973674+00	password	8547d1f4-149b-40ec-8f03-49c2ac2952cd
a8f2d17a-9f44-4da5-842e-bb69317e987c	2026-02-27 07:39:24.150584+00	2026-02-27 07:39:24.150584+00	password	bcda5c15-6f54-4499-932c-d7f93600a1a6
541ac0bc-3df8-4dc7-9769-c1246ecdd45c	2026-02-27 12:16:10.625134+00	2026-02-27 12:16:10.625134+00	password	6f4003dc-cf04-456c-b877-5c4bb6095228
a438af8b-7705-44be-b12a-e3fc7aa96314	2026-02-27 14:02:35.232971+00	2026-02-27 14:02:35.232971+00	password	1dcb19a7-67de-4fa6-becc-e310b5c5a36b
b0d3a4c7-121f-42b8-8ef6-09c519fd2068	2026-02-27 21:11:11.042311+00	2026-02-27 21:11:11.042311+00	password	a3e1cf88-7288-4568-a84a-107514c7d301
12be3362-7cd5-4400-97ce-b93b746dda56	2026-02-28 11:57:26.34768+00	2026-02-28 11:57:26.34768+00	password	ef198bbf-d4a7-4073-abbb-24419ec48053
ba9b8494-24b3-4931-ac1c-56f39c89173b	2026-02-28 16:29:35.394018+00	2026-02-28 16:29:35.394018+00	password	ca6462e5-cebf-4373-99cc-34f3b47ce409
e2ebfcc8-56fe-435a-86cc-3966a8b2b9ea	2026-03-01 07:57:28.639817+00	2026-03-01 07:57:28.639817+00	password	269eff0f-4619-463a-ad46-0521061e5a3c
13fdd596-fd78-4814-b0c7-7ce3260bab71	2026-03-03 10:58:17.392197+00	2026-03-03 10:58:17.392197+00	password	3d71fd87-ebed-45e3-a43c-a56dccde2b2a
59c188e5-0e1a-484f-a244-975f70554825	2026-03-03 17:29:51.158551+00	2026-03-03 17:29:51.158551+00	password	c453a7c5-8612-420e-8aa0-a335d9e727d8
7c58a9d3-f417-49da-a6eb-eed438347c9e	2026-03-03 17:33:19.280109+00	2026-03-03 17:33:19.280109+00	password	e2c03ea4-589c-4dd0-9193-f2fb2b54ba46
0542fb23-f10e-4594-8de0-498ed95a8341	2026-03-04 15:10:53.798404+00	2026-03-04 15:10:53.798404+00	password	5fff7907-ad89-42a9-b6ff-703abc260fce
d3504db3-2aa9-47b9-8b3a-4c7a06c40aeb	2026-03-05 10:10:38.143507+00	2026-03-05 10:10:38.143507+00	password	08fda8ad-0b20-48a0-ab1f-4aacb70d8e22
2fd777ec-6d8c-4f12-b553-6fad05fb2053	2026-03-09 10:23:51.766667+00	2026-03-09 10:23:51.766667+00	password	e309f7a7-14a1-4305-a773-5bdea714d4d4
708bb470-1253-4403-a9a2-bed497029491	2026-03-09 10:25:40.981022+00	2026-03-09 10:25:40.981022+00	password	72fdabb2-a84e-4bde-b2ac-c562eb446d0d
fa6fcc8c-6d2e-41f5-8425-eda1e998bbf9	2026-03-05 12:37:18.820211+00	2026-03-05 12:37:18.820211+00	password	60c299d5-e398-42f2-9b5b-dd194adf6361
ac0c7844-3e23-45c4-8226-1bfb88c36ddc	2026-03-09 10:27:30.571495+00	2026-03-09 10:27:30.571495+00	password	7e95ae6c-7a01-4ec8-934c-34ce17717012
3f281e0e-1cb9-4915-9604-9228e198e9f5	2026-03-09 10:32:02.828532+00	2026-03-09 10:32:02.828532+00	password	3646bfd5-750a-4eea-9609-316777f95660
148343c1-0667-48ef-8010-f0f00fa12bb3	2026-03-09 10:34:51.019162+00	2026-03-09 10:34:51.019162+00	password	26710ab6-966a-482d-b6e7-92f41c29cd74
8f6947bd-d612-40f0-85e7-f33c03b6025b	2026-03-05 19:09:07.513565+00	2026-03-05 19:09:07.513565+00	password	d5160751-a1a7-46df-97ab-20f15c7caf5f
f1d869fa-7f2b-48f3-b7ae-eb60042e4883	2026-03-05 19:12:42.3437+00	2026-03-05 19:12:42.3437+00	password	45b0dce8-bc38-490f-b637-a5bbd00a8643
04a1446b-a12f-44ab-90d5-08926c52861a	2026-03-09 13:48:09.295865+00	2026-03-09 13:48:09.295865+00	password	5adf99b4-8cd4-4ae8-80d0-fe2a473eaec0
a1964111-fed5-4c31-9a70-6bcc7bc06494	2026-03-10 14:12:46.821904+00	2026-03-10 14:12:46.821904+00	password	4370d16d-74a0-4cad-82c9-86e781eaf263
2673a89a-f8aa-4f8c-bd64-b2de217640d9	2026-03-10 14:55:13.285307+00	2026-03-10 14:55:13.285307+00	password	8b40e00f-0216-4faf-be20-40954deb4ce4
a5a32e36-9c2e-4a5c-b5e5-3d5ba9b5b983	2026-03-10 15:21:08.382046+00	2026-03-10 15:21:08.382046+00	password	dd53e0d5-c370-416b-9ceb-55b5519da661
885eb734-1be1-4749-b690-15d49b7bf830	2026-03-06 16:03:28.23932+00	2026-03-06 16:03:28.23932+00	password	657dda58-27a2-4d44-abc8-e6476fccecfb
f9ce0ceb-73af-4d0f-812d-349b2f0d17fb	2026-03-06 16:05:08.996345+00	2026-03-06 16:05:08.996345+00	password	4ef7fad3-659e-4aba-a154-87fe768c86ff
c55d7896-8914-4b9a-9fb6-33a38e561179	2026-03-07 07:42:51.9309+00	2026-03-07 07:42:51.9309+00	password	c368c0d5-ed85-40e7-9fde-c6b3ae12012f
ebbbf287-a0ea-4e5c-9a3d-1cf2db0e5865	2026-03-09 08:09:54.095826+00	2026-03-09 08:09:54.095826+00	password	fc606eca-afd4-47fe-98b0-b4ec5e6385f6
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
14f10484-9fcb-4971-b185-4ca6e9864f7c	2bb9bfb9-e2ac-41e9-9c2f-fbfa2c928de5	confirmation_token	ea9bb0467fa5e2d576629d573efef85b4659660202235bd6546716ac	uasea@mail.de	2026-02-17 11:00:46.986056	2026-02-17 11:00:46.986056
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	249	vx43ekcgsqym	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-22 09:49:34.126561+00	2026-02-22 09:49:34.126561+00	kv5klea6rjhs	7957ff95-3335-4487-b9e5-a5553f33b644
00000000-0000-0000-0000-000000000000	138	saxthefnxvqb	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-18 18:28:59.031179+00	2026-02-18 19:52:49.127224+00	\N	8324ab27-5e71-4e11-8cc6-243612f2892b
00000000-0000-0000-0000-000000000000	2	4ixskmsxrgoi	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-16 14:44:58.377521+00	2026-02-16 15:43:17.578953+00	\N	ba84d120-f4fd-437e-b391-2de5c6286f0c
00000000-0000-0000-0000-000000000000	3	cxlffhlo7eba	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-16 15:43:17.592489+00	2026-02-16 17:11:42.501222+00	4ixskmsxrgoi	ba84d120-f4fd-437e-b391-2de5c6286f0c
00000000-0000-0000-0000-000000000000	4	r2r54z2emuww	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-16 17:11:42.511459+00	2026-02-16 17:11:42.511459+00	cxlffhlo7eba	ba84d120-f4fd-437e-b391-2de5c6286f0c
00000000-0000-0000-0000-000000000000	141	x6trp6hfsr55	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-18 19:52:49.143942+00	2026-02-18 20:51:21.177509+00	saxthefnxvqb	8324ab27-5e71-4e11-8cc6-243612f2892b
00000000-0000-0000-0000-000000000000	6	ez66zuxdtqnw	e7450c22-ab44-440a-bfb7-bc14a9defb05	f	2026-02-16 18:05:19.26929+00	2026-02-16 18:05:19.26929+00	\N	fe5c6b89-8d21-4592-92b7-b12dbbd98e19
00000000-0000-0000-0000-000000000000	8	yf3pxugvth23	31536e18-7556-4d82-b41c-2ece065db4dc	f	2026-02-16 18:06:02.24321+00	2026-02-16 18:06:02.24321+00	\N	d9cdd500-4426-4a65-ae40-7ecab1610bca
00000000-0000-0000-0000-000000000000	9	v3cdqgleocgn	5d3560c5-3d76-4606-80e8-7eb69ce36a51	f	2026-02-16 19:02:59.385503+00	2026-02-16 19:02:59.385503+00	\N	0b9dae88-1c2b-46fd-afae-d74735be41dd
00000000-0000-0000-0000-000000000000	10	vodixdgwhyvy	db2eea71-c184-41bb-84bf-e6bb40c770fd	f	2026-02-16 19:04:05.939929+00	2026-02-16 19:04:05.939929+00	\N	95738a33-c019-4ac7-9877-0b7b4d73bf00
00000000-0000-0000-0000-000000000000	143	3qdp5leeqeef	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-18 20:51:21.19667+00	2026-02-18 21:49:23.456374+00	x6trp6hfsr55	8324ab27-5e71-4e11-8cc6-243612f2892b
00000000-0000-0000-0000-000000000000	679	v7vati775inf	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-05 15:04:04.472449+00	2026-03-05 18:20:49.269981+00	4buchk7snbq2	fa6fcc8c-6d2e-41f5-8425-eda1e998bbf9
00000000-0000-0000-0000-000000000000	147	ghepqsufypqj	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-19 06:38:04.428296+00	2026-02-19 08:02:58.018238+00	hqo6ggvsqh45	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	737	vru6qrcsa4qb	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-03-06 18:24:31.038087+00	2026-03-06 18:24:31.038087+00	y5nh6y2s6fny	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	16	gwi37mealequ	9852c5b1-e17b-402e-81fa-6b638f610264	t	2026-02-17 08:30:14.396889+00	2026-02-17 09:29:38.292848+00	\N	200fe79a-3d32-494b-a650-5fb95fe1bc50
00000000-0000-0000-0000-000000000000	17	ayp4gcgupcmj	9852c5b1-e17b-402e-81fa-6b638f610264	t	2026-02-17 09:29:38.300683+00	2026-02-17 10:30:08.855749+00	gwi37mealequ	200fe79a-3d32-494b-a650-5fb95fe1bc50
00000000-0000-0000-0000-000000000000	18	p4ta2wcpg3tj	9852c5b1-e17b-402e-81fa-6b638f610264	f	2026-02-17 10:30:08.866625+00	2026-02-17 10:30:08.866625+00	ayp4gcgupcmj	200fe79a-3d32-494b-a650-5fb95fe1bc50
00000000-0000-0000-0000-000000000000	145	7bwepqyb5god	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-18 22:54:57.438641+00	2026-02-19 10:12:10.680168+00	fv3of3wytimu	8324ab27-5e71-4e11-8cc6-243612f2892b
00000000-0000-0000-0000-000000000000	158	o2v5o2edrlks	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-19 10:12:10.689667+00	2026-02-19 10:12:10.689667+00	7bwepqyb5god	8324ab27-5e71-4e11-8cc6-243612f2892b
00000000-0000-0000-0000-000000000000	155	k6kjiqzm6k63	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-19 09:59:31.89512+00	2026-02-19 10:58:08.266813+00	afsaw3inhlm3	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	25	fl4em5um6okp	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-17 11:47:52.893533+00	2026-02-17 12:56:01.858965+00	\N	b64f9be4-2fa0-4d5b-b7c7-db97945c1b1c
00000000-0000-0000-0000-000000000000	26	lalj3avfzkb3	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-17 12:56:01.86736+00	2026-02-17 12:56:01.86736+00	fl4em5um6okp	b64f9be4-2fa0-4d5b-b7c7-db97945c1b1c
00000000-0000-0000-0000-000000000000	27	kxfokau7yjaa	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-17 12:59:22.870379+00	2026-02-17 12:59:22.870379+00	\N	fb798671-07e5-408f-9628-f8899062efb3
00000000-0000-0000-0000-000000000000	28	xykltztwwzzj	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-17 13:00:23.91172+00	2026-02-17 13:00:23.91172+00	\N	db50e822-dc01-4f52-95ff-beb029e29386
00000000-0000-0000-0000-000000000000	29	55wcii7bymqh	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-17 13:02:12.887739+00	2026-02-17 13:02:12.887739+00	\N	84a8567a-0cf7-4e75-8c83-f02a25b091ad
00000000-0000-0000-0000-000000000000	30	cgwvqigaptyy	d071f9b2-ce73-44a2-b015-2a2d8efe1503	f	2026-02-17 13:03:59.943087+00	2026-02-17 13:03:59.943087+00	\N	79a47e5c-dcaa-443d-9743-7590959daf1f
00000000-0000-0000-0000-000000000000	31	cun2axy27wpd	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-17 13:05:03.988682+00	2026-02-17 13:05:03.988682+00	\N	fdb73807-cbb2-45db-a8c0-e28be3c8fca8
00000000-0000-0000-0000-000000000000	32	kdsb5tjoi5tl	d071f9b2-ce73-44a2-b015-2a2d8efe1503	f	2026-02-17 13:05:08.770121+00	2026-02-17 13:05:08.770121+00	\N	7ce1fdaf-4a81-4e72-a29e-5b279ba0d0d1
00000000-0000-0000-0000-000000000000	33	x5vtqods6o2b	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-17 13:06:50.121547+00	2026-02-17 13:06:50.121547+00	\N	5f5fcd62-060d-498b-a0c4-cf959578ed0e
00000000-0000-0000-0000-000000000000	34	zzi64cx5j2tv	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-17 13:14:07.730755+00	2026-02-17 13:14:07.730755+00	\N	e12199cd-6b8e-43f6-bf83-a23c0b1163e0
00000000-0000-0000-0000-000000000000	35	x44waj5ioruj	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-17 13:39:46.227561+00	2026-02-17 13:39:46.227561+00	\N	2775d9f0-f93e-4f89-be9d-187ba88836f9
00000000-0000-0000-0000-000000000000	36	jral7bcq5kjw	d071f9b2-ce73-44a2-b015-2a2d8efe1503	f	2026-02-17 14:00:03.616799+00	2026-02-17 14:00:03.616799+00	\N	41662b58-18d5-406e-b68c-f39a28e1a022
00000000-0000-0000-0000-000000000000	37	ynoiwbv2sfgg	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	f	2026-02-17 14:00:33.555217+00	2026-02-17 14:00:33.555217+00	\N	890751a4-5d95-4c37-a28d-40c8af6cf6e3
00000000-0000-0000-0000-000000000000	38	7hc7drz4t35u	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-17 14:00:37.575886+00	2026-02-17 14:00:37.575886+00	\N	2e8c68ff-d5d2-45f1-b5bc-a658f4a09711
00000000-0000-0000-0000-000000000000	39	gnr5tbv2o6sw	d071f9b2-ce73-44a2-b015-2a2d8efe1503	f	2026-02-17 14:01:25.467916+00	2026-02-17 14:01:25.467916+00	\N	59b912ee-7ee4-4086-bbca-ec38bd7e35d0
00000000-0000-0000-0000-000000000000	40	4uztw4ubtfao	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	f	2026-02-17 14:02:31.244199+00	2026-02-17 14:02:31.244199+00	\N	0a93fd1e-3b17-4ca7-be1a-5a4aeb0338c0
00000000-0000-0000-0000-000000000000	41	uovprqwd6zpt	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	f	2026-02-17 14:02:49.685483+00	2026-02-17 14:02:49.685483+00	\N	bac69b22-b81d-4391-beae-2641151c7e64
00000000-0000-0000-0000-000000000000	42	nfhfwasfd5rt	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-17 14:03:15.591386+00	2026-02-17 14:03:15.591386+00	\N	9be04c45-692e-4eec-8bd5-1d2a905006d7
00000000-0000-0000-0000-000000000000	43	z2j2oygvhc5b	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	f	2026-02-17 14:04:00.737577+00	2026-02-17 14:04:00.737577+00	\N	ebb842f9-ce26-4226-8e02-94262484b4e0
00000000-0000-0000-0000-000000000000	44	bbpdl6asy2dr	d071f9b2-ce73-44a2-b015-2a2d8efe1503	f	2026-02-17 14:04:20.20387+00	2026-02-17 14:04:20.20387+00	\N	30e1867a-a5f3-403d-a322-02e78015d89f
00000000-0000-0000-0000-000000000000	45	hxburfbzrhww	d071f9b2-ce73-44a2-b015-2a2d8efe1503	f	2026-02-17 14:05:27.33583+00	2026-02-17 14:05:27.33583+00	\N	7e6adb9a-b376-4b10-b061-e22a3b32feb4
00000000-0000-0000-0000-000000000000	46	2lgjznyd5l2m	d071f9b2-ce73-44a2-b015-2a2d8efe1503	f	2026-02-17 14:05:37.605258+00	2026-02-17 14:05:37.605258+00	\N	2c1bb0b7-5b1d-4bbf-a879-4380a070e555
00000000-0000-0000-0000-000000000000	159	ykvqv35yecsw	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-19 10:12:12.6387+00	2026-02-19 11:22:16.011163+00	\N	5b71cd4c-c447-4f04-92be-5afcc9db5d36
00000000-0000-0000-0000-000000000000	163	3jvptbbd3ftr	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-19 11:22:16.024235+00	2026-02-19 11:22:16.024235+00	ykvqv35yecsw	5b71cd4c-c447-4f04-92be-5afcc9db5d36
00000000-0000-0000-0000-000000000000	836	2lkour7n5jmx	fdaf6d5b-b6de-4dcb-bcb5-fbf0276736bf	t	2026-03-10 15:21:08.363825+00	2026-03-11 07:41:11.749509+00	\N	a5a32e36-9c2e-4a5c-b5e5-3d5ba9b5b983
00000000-0000-0000-0000-000000000000	166	aj74daix2ti7	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-19 12:12:41.853625+00	2026-02-19 13:10:42.457794+00	\N	bbaf75e5-e893-40b9-af88-1feb9d976d12
00000000-0000-0000-0000-000000000000	167	3ll3gffmsw65	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-19 12:31:19.945181+00	2026-02-19 13:30:12.438713+00	mkih3yux2dph	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	47	wq7n763ole5o	d071f9b2-ce73-44a2-b015-2a2d8efe1503	f	2026-02-17 14:06:49.837922+00	2026-02-17 14:06:49.837922+00	\N	7f1758a0-617c-494b-beb3-c99e2c86817c
00000000-0000-0000-0000-000000000000	754	7tmentaqhh6t	14c5bf86-010f-4355-b352-200ddc0c4aee	f	2026-03-07 07:42:51.926187+00	2026-03-07 07:42:51.926187+00	\N	c55d7896-8914-4b9a-9fb6-33a38e561179
00000000-0000-0000-0000-000000000000	49	unndm7dg45p3	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-17 14:10:06.572931+00	2026-02-17 14:10:06.572931+00	\N	35c7f1de-31b9-4a4e-a76c-c891d633180f
00000000-0000-0000-0000-000000000000	50	jplgj2vdsto4	560902da-285b-493c-8d46-16be17996519	f	2026-02-17 14:12:16.810062+00	2026-02-17 14:12:16.810062+00	\N	3256efed-2514-49a3-9e8b-55b55c4b3826
00000000-0000-0000-0000-000000000000	51	r37fkjpynjga	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	f	2026-02-17 14:14:13.666493+00	2026-02-17 14:14:13.666493+00	\N	94ea9f8d-e09e-4ddb-ba75-bb37ba8416a4
00000000-0000-0000-0000-000000000000	52	2zfyikpj2dcs	d071f9b2-ce73-44a2-b015-2a2d8efe1503	f	2026-02-17 14:19:15.816515+00	2026-02-17 14:19:15.816515+00	\N	499b0b19-fc82-437e-8bd0-47b9ed36df9a
00000000-0000-0000-0000-000000000000	53	knqhwhozw64e	d071f9b2-ce73-44a2-b015-2a2d8efe1503	f	2026-02-17 14:22:15.485195+00	2026-02-17 14:22:15.485195+00	\N	81ac6413-11a1-4430-a035-c4bb4a3451cd
00000000-0000-0000-0000-000000000000	54	tyq7fwhxkwwj	86c1d4b2-d9b8-4972-880c-9a8d3220d1d1	f	2026-02-17 14:23:29.845949+00	2026-02-17 14:23:29.845949+00	\N	29944caf-1aa9-416c-be71-5a33f6a8490e
00000000-0000-0000-0000-000000000000	56	cgppxthkqbi7	312fbd38-46b4-4611-bf01-ea5b58854967	f	2026-02-17 14:25:19.793792+00	2026-02-17 14:25:19.793792+00	\N	83390bb2-9482-419b-aff5-1b747f57e9fa
00000000-0000-0000-0000-000000000000	58	tm7hckoisvx2	d071f9b2-ce73-44a2-b015-2a2d8efe1503	f	2026-02-17 14:31:53.917604+00	2026-02-17 14:31:53.917604+00	\N	bb6c0eae-ae89-426c-9419-4cf74def72f1
00000000-0000-0000-0000-000000000000	59	ashc2zhggyel	d071f9b2-ce73-44a2-b015-2a2d8efe1503	f	2026-02-17 14:38:57.10545+00	2026-02-17 14:38:57.10545+00	\N	12e61b4b-d4a7-44e7-98e1-5699626a9eed
00000000-0000-0000-0000-000000000000	60	4fnguvx7ecpe	560902da-285b-493c-8d46-16be17996519	f	2026-02-17 14:39:21.280457+00	2026-02-17 14:39:21.280457+00	\N	763254bb-c2aa-49a7-800a-53e670a85ac3
00000000-0000-0000-0000-000000000000	61	kqtzq6xyli2r	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	f	2026-02-17 14:39:40.473823+00	2026-02-17 14:39:40.473823+00	\N	18e99fae-79cc-4948-bb55-fc4e875776e3
00000000-0000-0000-0000-000000000000	62	blac2jkejjzk	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	f	2026-02-17 14:41:22.879371+00	2026-02-17 14:41:22.879371+00	\N	3af17e5e-a1e9-458f-b009-aa57f1a995ff
00000000-0000-0000-0000-000000000000	48	ryiqz2nxjjrn	d071f9b2-ce73-44a2-b015-2a2d8efe1503	t	2026-02-17 14:08:22.936359+00	2026-02-17 15:06:35.605665+00	\N	25c2e177-3b97-4c31-9c0b-ef7bfa223b39
00000000-0000-0000-0000-000000000000	55	amxjmhit37kh	86c1d4b2-d9b8-4972-880c-9a8d3220d1d1	t	2026-02-17 14:23:44.619889+00	2026-02-17 15:34:28.532257+00	\N	d06e7ef5-0cf3-4314-8702-1fb775b7e857
00000000-0000-0000-0000-000000000000	65	4rczhd2ojjnm	86c1d4b2-d9b8-4972-880c-9a8d3220d1d1	f	2026-02-17 15:34:28.547153+00	2026-02-17 15:34:28.547153+00	amxjmhit37kh	d06e7ef5-0cf3-4314-8702-1fb775b7e857
00000000-0000-0000-0000-000000000000	66	cjf3banqsw3j	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	f	2026-02-17 15:34:47.94935+00	2026-02-17 15:34:47.94935+00	\N	55461262-cf41-4cdf-b2b0-02946a87b74c
00000000-0000-0000-0000-000000000000	57	rldeshl4oqje	d071f9b2-ce73-44a2-b015-2a2d8efe1503	t	2026-02-17 14:31:24.443334+00	2026-02-17 15:39:41.181091+00	\N	00ec2db2-5612-4fe5-b679-42f485fb1a80
00000000-0000-0000-0000-000000000000	68	ljumwdvpscwg	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	f	2026-02-17 15:45:12.251472+00	2026-02-17 15:45:12.251472+00	\N	b73698ca-262b-49e3-89f5-abca6e255bf8
00000000-0000-0000-0000-000000000000	69	wr64qqqgnvkk	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	f	2026-02-17 15:45:29.773844+00	2026-02-17 15:45:29.773844+00	\N	3f480e29-9bc1-4a0a-ae48-80f93b5955ae
00000000-0000-0000-0000-000000000000	64	vxp27oijv75o	d071f9b2-ce73-44a2-b015-2a2d8efe1503	t	2026-02-17 15:06:35.63572+00	2026-02-17 16:04:38.483998+00	ryiqz2nxjjrn	25c2e177-3b97-4c31-9c0b-ef7bfa223b39
00000000-0000-0000-0000-000000000000	63	qelpu4aubnzi	560902da-285b-493c-8d46-16be17996519	t	2026-02-17 14:41:44.112784+00	2026-02-17 16:36:28.714888+00	\N	12a538c9-838d-40eb-9f82-ce3ddbaeead4
00000000-0000-0000-0000-000000000000	72	fvig7ivw6gic	560902da-285b-493c-8d46-16be17996519	f	2026-02-17 16:36:28.739078+00	2026-02-17 16:36:28.739078+00	qelpu4aubnzi	12a538c9-838d-40eb-9f82-ce3ddbaeead4
00000000-0000-0000-0000-000000000000	73	sxjcas7s5spa	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-17 16:37:24.634373+00	2026-02-17 16:37:24.634373+00	\N	78cd1562-7867-441e-9df4-f74e6a651f51
00000000-0000-0000-0000-000000000000	74	uvafknqdrq7y	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-17 16:37:54.778047+00	2026-02-17 16:37:54.778047+00	\N	6d69da0f-d7b5-42bb-862c-d3849016fec8
00000000-0000-0000-0000-000000000000	75	drcnh5vvrfm4	d071f9b2-ce73-44a2-b015-2a2d8efe1503	f	2026-02-17 16:38:19.663199+00	2026-02-17 16:38:19.663199+00	\N	0a17f5ce-dd3c-4008-b0ae-5fee1875f52a
00000000-0000-0000-0000-000000000000	76	wtl6i6zqrav3	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-17 16:38:31.473147+00	2026-02-17 16:38:31.473147+00	\N	1854594f-d9b9-41c4-b1e4-65fec4b7ce15
00000000-0000-0000-0000-000000000000	67	leth2br3ypdo	d071f9b2-ce73-44a2-b015-2a2d8efe1503	t	2026-02-17 15:39:41.182141+00	2026-02-17 16:41:23.300696+00	rldeshl4oqje	00ec2db2-5612-4fe5-b679-42f485fb1a80
00000000-0000-0000-0000-000000000000	77	7a3mdup4qhew	d071f9b2-ce73-44a2-b015-2a2d8efe1503	f	2026-02-17 16:41:23.306707+00	2026-02-17 16:41:23.306707+00	leth2br3ypdo	00ec2db2-5612-4fe5-b679-42f485fb1a80
00000000-0000-0000-0000-000000000000	78	t3uuz6idpfix	a1d1c5fa-e722-4251-907c-afd134b085df	f	2026-02-17 16:46:30.318917+00	2026-02-17 16:46:30.318917+00	\N	3d32c47a-d4bf-432c-9119-cb99560ef38d
00000000-0000-0000-0000-000000000000	79	5jpijkgwzms5	a1d1c5fa-e722-4251-907c-afd134b085df	f	2026-02-17 16:46:42.410072+00	2026-02-17 16:46:42.410072+00	\N	df825fb5-6320-433e-bdbc-81447e80c041
00000000-0000-0000-0000-000000000000	80	r3aev5txy6l2	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-17 16:47:13.152427+00	2026-02-17 16:47:13.152427+00	\N	54cff7fd-f7f3-44d0-ad91-8bfd4cd79708
00000000-0000-0000-0000-000000000000	70	vegwyc4dzorx	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	t	2026-02-17 15:54:53.484777+00	2026-02-17 17:23:37.483777+00	\N	d7bbf19c-ca78-4a08-a8a5-36ee95156d3a
00000000-0000-0000-0000-000000000000	83	v3c7lpzbksm5	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	f	2026-02-17 17:23:37.497487+00	2026-02-17 17:23:37.497487+00	vegwyc4dzorx	d7bbf19c-ca78-4a08-a8a5-36ee95156d3a
00000000-0000-0000-0000-000000000000	81	holbizkgtzd4	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-17 16:57:08.087205+00	2026-02-17 18:11:01.426055+00	\N	7808b525-3751-4459-9abe-ab37f167a967
00000000-0000-0000-0000-000000000000	71	i5ygoddc67qf	d071f9b2-ce73-44a2-b015-2a2d8efe1503	t	2026-02-17 16:04:38.499219+00	2026-02-17 19:06:33.559829+00	vxp27oijv75o	25c2e177-3b97-4c31-9c0b-ef7bfa223b39
00000000-0000-0000-0000-000000000000	85	ksrsijkxzjic	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-17 18:11:01.433628+00	2026-02-17 19:09:24.603327+00	holbizkgtzd4	7808b525-3751-4459-9abe-ab37f167a967
00000000-0000-0000-0000-000000000000	84	ur76hsylj6op	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	t	2026-02-17 17:28:01.511643+00	2026-02-17 20:37:20.894162+00	\N	4d63bee2-24ad-48d7-af90-1b02ac4370cf
00000000-0000-0000-0000-000000000000	86	kbkqgdcd6kj3	d071f9b2-ce73-44a2-b015-2a2d8efe1503	t	2026-02-17 19:06:33.587952+00	2026-02-18 06:16:18.601058+00	i5ygoddc67qf	25c2e177-3b97-4c31-9c0b-ef7bfa223b39
00000000-0000-0000-0000-000000000000	89	pskyaswht22a	d071f9b2-ce73-44a2-b015-2a2d8efe1503	t	2026-02-18 06:16:18.629341+00	2026-02-18 07:14:47.747126+00	kbkqgdcd6kj3	25c2e177-3b97-4c31-9c0b-ef7bfa223b39
00000000-0000-0000-0000-000000000000	88	njlwthvqkox7	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	t	2026-02-17 20:37:20.911429+00	2026-02-18 07:19:37.517176+00	ur76hsylj6op	4d63bee2-24ad-48d7-af90-1b02ac4370cf
00000000-0000-0000-0000-000000000000	87	47hwhmcz3wtc	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-17 19:09:24.604312+00	2026-02-18 08:07:00.81838+00	ksrsijkxzjic	7808b525-3751-4459-9abe-ab37f167a967
00000000-0000-0000-0000-000000000000	92	lydloecx5w6d	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-18 08:07:00.831061+00	2026-02-18 08:07:00.831061+00	47hwhmcz3wtc	7808b525-3751-4459-9abe-ab37f167a967
00000000-0000-0000-0000-000000000000	93	4cpmdrecnzka	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-18 08:10:08.433993+00	2026-02-18 08:10:08.433993+00	\N	e485928a-a49f-438b-9f1d-354e8eba91aa
00000000-0000-0000-0000-000000000000	94	qtbj5l552elg	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-18 08:12:20.570024+00	2026-02-18 08:12:20.570024+00	\N	4ab51fe5-a56d-43b7-a376-e3fdb9b1f91a
00000000-0000-0000-0000-000000000000	90	rjb6xoa2hsqf	d071f9b2-ce73-44a2-b015-2a2d8efe1503	t	2026-02-18 07:14:47.763144+00	2026-02-18 08:13:15.941999+00	pskyaswht22a	25c2e177-3b97-4c31-9c0b-ef7bfa223b39
00000000-0000-0000-0000-000000000000	96	uslsh4spcpsi	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-18 08:14:02.260784+00	2026-02-18 08:14:02.260784+00	\N	ab835af8-c718-49a0-82ff-d54fd2d3727a
00000000-0000-0000-0000-000000000000	91	fk7dyxo667xw	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	t	2026-02-18 07:19:37.518188+00	2026-02-18 08:17:49.487469+00	njlwthvqkox7	4d63bee2-24ad-48d7-af90-1b02ac4370cf
00000000-0000-0000-0000-000000000000	95	7w4fmtxfqryr	d071f9b2-ce73-44a2-b015-2a2d8efe1503	t	2026-02-18 08:13:15.993189+00	2026-02-18 09:11:19.851423+00	rjb6xoa2hsqf	25c2e177-3b97-4c31-9c0b-ef7bfa223b39
00000000-0000-0000-0000-000000000000	97	fols7xyikldl	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-18 08:17:13.878352+00	2026-02-18 09:15:21.781452+00	\N	5a0582f2-27ef-497d-9f8f-d2c202dcf389
00000000-0000-0000-0000-000000000000	98	h42ffsqcg7zi	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	t	2026-02-18 08:17:49.488112+00	2026-02-18 09:20:15.941919+00	fk7dyxo667xw	4d63bee2-24ad-48d7-af90-1b02ac4370cf
00000000-0000-0000-0000-000000000000	82	ho5lrywjypdn	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-17 16:57:09.588936+00	2026-02-18 11:50:46.335584+00	\N	05c44ef7-1679-4e3b-8184-0e848e32dcf8
00000000-0000-0000-0000-000000000000	668	oy2yovmd6gbv	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-05 10:58:42.654169+00	2026-03-05 11:57:07.184854+00	f6njptz6w4ja	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	101	iotf5gq34ni4	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	f	2026-02-18 09:20:15.943443+00	2026-02-18 09:20:15.943443+00	h42ffsqcg7zi	4d63bee2-24ad-48d7-af90-1b02ac4370cf
00000000-0000-0000-0000-000000000000	102	mjjrbnavtft7	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	f	2026-02-18 09:27:24.331199+00	2026-02-18 09:27:24.331199+00	\N	7ffb102c-41c9-4a1b-94a7-92df379af1df
00000000-0000-0000-0000-000000000000	99	5vydqpnuyppn	d071f9b2-ce73-44a2-b015-2a2d8efe1503	t	2026-02-18 09:11:19.868134+00	2026-02-18 10:09:19.926017+00	7w4fmtxfqryr	25c2e177-3b97-4c31-9c0b-ef7bfa223b39
00000000-0000-0000-0000-000000000000	100	leawz3bk5fiu	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-18 09:15:21.796485+00	2026-02-18 10:32:04.098248+00	fols7xyikldl	5a0582f2-27ef-497d-9f8f-d2c202dcf389
00000000-0000-0000-0000-000000000000	106	q3xg7ftdietp	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-18 10:32:04.10252+00	2026-02-18 10:32:04.10252+00	leawz3bk5fiu	5a0582f2-27ef-497d-9f8f-d2c202dcf389
00000000-0000-0000-0000-000000000000	104	r3osxbsiy5wu	d071f9b2-ce73-44a2-b015-2a2d8efe1503	t	2026-02-18 10:09:19.939361+00	2026-02-18 11:07:46.550798+00	5vydqpnuyppn	25c2e177-3b97-4c31-9c0b-ef7bfa223b39
00000000-0000-0000-0000-000000000000	108	jt25mmx3ruyf	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-18 11:09:18.092834+00	2026-02-18 11:09:18.092834+00	\N	d8582c75-1e8d-44ac-8c63-4fdf856c646b
00000000-0000-0000-0000-000000000000	109	sjsk3h76knll	306b5d39-a4ee-4848-a64a-01ad4ffa241d	f	2026-02-18 11:23:23.565654+00	2026-02-18 11:23:23.565654+00	\N	f275c52e-f385-43ed-86e2-e988d5b7795d
00000000-0000-0000-0000-000000000000	110	huvi4ula5eny	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	f	2026-02-18 11:23:40.999545+00	2026-02-18 11:23:40.999545+00	\N	6a4d01e9-cad7-4723-8845-b6466a2174a8
00000000-0000-0000-0000-000000000000	144	fv3of3wytimu	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-18 21:49:23.465961+00	2026-02-18 22:54:57.420497+00	3qdp5leeqeef	8324ab27-5e71-4e11-8cc6-243612f2892b
00000000-0000-0000-0000-000000000000	113	clonxpdqlck2	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-18 11:50:46.363357+00	2026-02-18 11:50:46.363357+00	ho5lrywjypdn	05c44ef7-1679-4e3b-8184-0e848e32dcf8
00000000-0000-0000-0000-000000000000	107	pcvf5bsdpw5a	d071f9b2-ce73-44a2-b015-2a2d8efe1503	t	2026-02-18 11:07:46.568382+00	2026-02-18 12:06:01.789276+00	r3osxbsiy5wu	25c2e177-3b97-4c31-9c0b-ef7bfa223b39
00000000-0000-0000-0000-000000000000	137	hqo6ggvsqh45	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-18 18:11:27.946066+00	2026-02-19 06:38:04.402728+00	2ty2yx4wfy2v	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	851	yvpra3r5jysc	fdaf6d5b-b6de-4dcb-bcb5-fbf0276736bf	f	2026-03-11 09:26:32.226929+00	2026-03-11 09:26:32.226929+00	izq5hspq2x3m	a5a32e36-9c2e-4a5c-b5e5-3d5ba9b5b983
00000000-0000-0000-0000-000000000000	112	t47megzw6cgg	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-18 11:26:26.019387+00	2026-02-18 12:51:01.925412+00	\N	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	114	qf4rqgxwzrie	d071f9b2-ce73-44a2-b015-2a2d8efe1503	t	2026-02-18 12:06:01.799289+00	2026-02-18 13:04:02.241162+00	pcvf5bsdpw5a	25c2e177-3b97-4c31-9c0b-ef7bfa223b39
00000000-0000-0000-0000-000000000000	116	jdtngs35ntjw	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-18 12:37:46.327894+00	2026-02-18 13:36:01.939072+00	\N	2521feb6-ff7f-48c6-ad67-a59bbdd80ebe
00000000-0000-0000-0000-000000000000	117	4inuy73hb3pi	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-18 12:51:01.934977+00	2026-02-18 13:49:26.470235+00	t47megzw6cgg	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	150	pp4flxcp2pgr	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-19 08:02:58.028952+00	2026-02-19 09:01:16.613688+00	ghepqsufypqj	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	118	mfrznuc7okkp	d071f9b2-ce73-44a2-b015-2a2d8efe1503	t	2026-02-18 13:04:02.261158+00	2026-02-18 14:02:08.940406+00	qf4rqgxwzrie	25c2e177-3b97-4c31-9c0b-ef7bfa223b39
00000000-0000-0000-0000-000000000000	120	djpffffuj2mh	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-18 13:36:01.942544+00	2026-02-18 14:34:07.66371+00	jdtngs35ntjw	2521feb6-ff7f-48c6-ad67-a59bbdd80ebe
00000000-0000-0000-0000-000000000000	152	afsaw3inhlm3	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-19 09:01:16.629005+00	2026-02-19 09:59:31.883781+00	pp4flxcp2pgr	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	121	bkyjf4mi2mle	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-18 13:49:26.475248+00	2026-02-18 14:47:57.864676+00	4inuy73hb3pi	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	122	fc2dvbgudszr	d071f9b2-ce73-44a2-b015-2a2d8efe1503	t	2026-02-18 14:02:08.95148+00	2026-02-18 15:00:19.197784+00	mfrznuc7okkp	25c2e177-3b97-4c31-9c0b-ef7bfa223b39
00000000-0000-0000-0000-000000000000	124	urrdkznunrgd	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-18 14:34:07.677181+00	2026-02-18 15:32:56.973476+00	djpffffuj2mh	2521feb6-ff7f-48c6-ad67-a59bbdd80ebe
00000000-0000-0000-0000-000000000000	125	ukqfwgfpnwu6	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-18 14:47:57.866975+00	2026-02-18 15:46:09.369998+00	bkyjf4mi2mle	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	126	45req3tk5zzj	d071f9b2-ce73-44a2-b015-2a2d8efe1503	t	2026-02-18 15:00:19.202622+00	2026-02-18 15:58:24.236065+00	fc2dvbgudszr	25c2e177-3b97-4c31-9c0b-ef7bfa223b39
00000000-0000-0000-0000-000000000000	130	7mnfgf63ldhx	d071f9b2-ce73-44a2-b015-2a2d8efe1503	f	2026-02-18 15:58:24.245123+00	2026-02-18 15:58:24.245123+00	45req3tk5zzj	25c2e177-3b97-4c31-9c0b-ef7bfa223b39
00000000-0000-0000-0000-000000000000	129	oe6yzyn6enb4	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-18 15:46:09.397684+00	2026-02-18 17:06:26.866928+00	ukqfwgfpnwu6	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	160	mkih3yux2dph	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-19 10:58:08.284678+00	2026-02-19 12:31:19.925378+00	k6kjiqzm6k63	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	128	tk5igc4epymh	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-18 15:32:56.987699+00	2026-02-18 17:10:30.898661+00	urrdkznunrgd	2521feb6-ff7f-48c6-ad67-a59bbdd80ebe
00000000-0000-0000-0000-000000000000	134	ge4gz2ine6hx	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-18 17:10:30.910323+00	2026-02-18 18:10:09.352059+00	tk5igc4epymh	2521feb6-ff7f-48c6-ad67-a59bbdd80ebe
00000000-0000-0000-0000-000000000000	135	jkj67hzgscpm	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-18 18:10:09.365581+00	2026-02-18 18:10:09.365581+00	ge4gz2ine6hx	2521feb6-ff7f-48c6-ad67-a59bbdd80ebe
00000000-0000-0000-0000-000000000000	133	2ty2yx4wfy2v	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-18 17:06:26.886559+00	2026-02-18 18:11:27.945078+00	oe6yzyn6enb4	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	170	qq3aaotyjlk5	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-19 13:10:42.471197+00	2026-02-19 14:08:44.795166+00	aj74daix2ti7	bbaf75e5-e893-40b9-af88-1feb9d976d12
00000000-0000-0000-0000-000000000000	174	4esgmuce64ka	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-19 14:08:44.79908+00	2026-02-19 14:08:44.79908+00	qq3aaotyjlk5	bbaf75e5-e893-40b9-af88-1feb9d976d12
00000000-0000-0000-0000-000000000000	171	jnbmlidb3b62	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-19 13:30:12.445505+00	2026-02-19 14:28:22.754743+00	3ll3gffmsw65	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	175	bz4hp7eznvx5	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-19 14:26:00.282093+00	2026-02-19 15:24:03.860434+00	\N	01413de3-2563-4c2e-ab2f-7fca2e016dac
00000000-0000-0000-0000-000000000000	176	ep7mpvg5wqpq	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-19 14:28:22.758007+00	2026-02-19 15:26:23.478004+00	jnbmlidb3b62	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	838	lkmgpoiuj2zv	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-10 15:54:22.166+00	2026-03-10 17:43:00.289684+00	gqdbc5hitos7	2673a89a-f8aa-4f8c-bd64-b2de217640d9
00000000-0000-0000-0000-000000000000	180	z6px7jef2ant	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-19 15:26:23.479434+00	2026-02-19 18:14:16.615181+00	ep7mpvg5wqpq	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	179	siqonyzcptmj	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-19 15:24:03.880677+00	2026-02-19 18:15:33.63742+00	bz4hp7eznvx5	01413de3-2563-4c2e-ab2f-7fca2e016dac
00000000-0000-0000-0000-000000000000	183	ratgu4slpt7o	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-19 18:14:16.626454+00	2026-02-19 19:12:22.416331+00	z6px7jef2ant	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	184	kghhlo7ztclu	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-19 18:15:33.638475+00	2026-02-19 19:14:43.895082+00	siqonyzcptmj	01413de3-2563-4c2e-ab2f-7fca2e016dac
00000000-0000-0000-0000-000000000000	187	g7yc6jcbghr2	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-19 19:12:22.42808+00	2026-02-19 20:10:33.896247+00	ratgu4slpt7o	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	188	4vxw6suyttte	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-19 19:14:43.898409+00	2026-02-19 20:13:04.97026+00	kghhlo7ztclu	01413de3-2563-4c2e-ab2f-7fca2e016dac
00000000-0000-0000-0000-000000000000	190	676c5reg3br3	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-19 20:10:33.906991+00	2026-02-19 21:17:00.297988+00	g7yc6jcbghr2	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	192	awowqxriuab4	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-19 21:17:00.3157+00	2026-02-20 06:05:05.231163+00	676c5reg3br3	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	193	ssapijr5hbsr	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-20 06:05:05.252454+00	2026-02-20 07:03:13.838238+00	awowqxriuab4	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	194	6bp3ei2kvylw	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-20 07:03:13.869506+00	2026-02-20 08:01:57.125003+00	ssapijr5hbsr	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	191	viuihk3nysfb	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-19 20:13:04.97211+00	2026-02-20 08:36:23.507164+00	4vxw6suyttte	01413de3-2563-4c2e-ab2f-7fca2e016dac
00000000-0000-0000-0000-000000000000	197	gt2lxnuwxiij	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-20 08:01:57.132459+00	2026-02-20 09:00:10.147002+00	6bp3ei2kvylw	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	199	4r6jj6l5ded6	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-20 08:36:23.519012+00	2026-02-20 09:34:43.618455+00	viuihk3nysfb	01413de3-2563-4c2e-ab2f-7fca2e016dac
00000000-0000-0000-0000-000000000000	201	n3epeh7hbx3f	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-20 09:00:10.150973+00	2026-02-20 09:58:25.714074+00	gt2lxnuwxiij	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	205	3yhx2kt4ghgu	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-20 09:58:25.723336+00	2026-02-20 09:58:25.723336+00	n3epeh7hbx3f	0846d543-467e-4f12-8347-9260486bf249
00000000-0000-0000-0000-000000000000	203	ql7sxej5xdml	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-20 09:34:43.626817+00	2026-02-20 10:32:43.421518+00	4r6jj6l5ded6	01413de3-2563-4c2e-ab2f-7fca2e016dac
00000000-0000-0000-0000-000000000000	210	eakbpwo5qb2o	306b5d39-a4ee-4848-a64a-01ad4ffa241d	f	2026-02-20 10:55:34.72282+00	2026-02-20 10:55:34.72282+00	\N	29b13c37-a5d5-4295-b568-73f5b08024dc
00000000-0000-0000-0000-000000000000	208	pzywj55mm4j5	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-20 10:32:43.422557+00	2026-02-20 11:43:20.023463+00	ql7sxej5xdml	01413de3-2563-4c2e-ab2f-7fca2e016dac
00000000-0000-0000-0000-000000000000	213	nxisz4m7q2qe	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-20 11:43:20.03735+00	2026-02-20 11:43:20.03735+00	pzywj55mm4j5	01413de3-2563-4c2e-ab2f-7fca2e016dac
00000000-0000-0000-0000-000000000000	206	xcvs4m4gpk7l	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-20 10:18:28.974254+00	2026-02-20 11:46:00.270388+00	\N	5501bda7-4d4b-4afc-a8b7-0921399db3e9
00000000-0000-0000-0000-000000000000	211	qtdewll6usgi	306b5d39-a4ee-4848-a64a-01ad4ffa241d	t	2026-02-20 10:56:08.495676+00	2026-02-20 12:23:43.320543+00	\N	95570d1b-b072-4ab4-be37-857176670cf9
00000000-0000-0000-0000-000000000000	216	bpamimazpvr4	306b5d39-a4ee-4848-a64a-01ad4ffa241d	f	2026-02-20 12:23:43.329529+00	2026-02-20 12:23:43.329529+00	qtdewll6usgi	95570d1b-b072-4ab4-be37-857176670cf9
00000000-0000-0000-0000-000000000000	214	cn7ka3y3ogm4	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-20 11:46:00.275482+00	2026-02-20 12:49:51.681782+00	xcvs4m4gpk7l	5501bda7-4d4b-4afc-a8b7-0921399db3e9
00000000-0000-0000-0000-000000000000	218	scxcqsg7l2mf	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-20 12:33:50.919112+00	2026-02-20 13:32:14.421107+00	\N	05824fe1-98de-4ba1-9b75-4e08d7cac146
00000000-0000-0000-0000-000000000000	219	niqirdf6qg7b	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-20 12:38:30.562938+00	2026-02-20 15:38:53.417529+00	\N	5c7870be-5b05-4ada-b5a3-b94bfbb75442
00000000-0000-0000-0000-000000000000	239	kv5klea6rjhs	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-20 15:37:24.956816+00	2026-02-22 09:49:34.105892+00	qr35tsk7ptz7	7957ff95-3335-4487-b9e5-a5553f33b644
00000000-0000-0000-0000-000000000000	221	m6emfkunmp5z	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-20 12:55:33.447052+00	2026-02-20 12:55:33.447052+00	\N	72f67b78-5c73-4add-947a-ae4ccc504d5a
00000000-0000-0000-0000-000000000000	225	vi7ygtixlbdr	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-20 13:32:14.4222+00	2026-02-20 13:32:14.4222+00	scxcqsg7l2mf	05824fe1-98de-4ba1-9b75-4e08d7cac146
00000000-0000-0000-0000-000000000000	683	54jb57nyqy2d	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-03-05 18:20:49.303352+00	2026-03-05 18:20:49.303352+00	v7vati775inf	fa6fcc8c-6d2e-41f5-8425-eda1e998bbf9
00000000-0000-0000-0000-000000000000	264	3bzchdw4vci6	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	t	2026-02-23 10:07:54.806315+00	2026-03-04 07:54:10.176428+00	htlaa56aulyv	1c4def97-0027-4852-83cd-6a71ffc224af
00000000-0000-0000-0000-000000000000	226	7wck4pzvqnz6	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-20 13:53:12.285596+00	2026-02-20 15:12:36.180141+00	\N	922e9c32-e9ac-4b59-9b1c-faee37586f69
00000000-0000-0000-0000-000000000000	230	wqyhnwmdrztr	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-20 15:12:36.180887+00	2026-02-20 15:12:36.180887+00	7wck4pzvqnz6	922e9c32-e9ac-4b59-9b1c-faee37586f69
00000000-0000-0000-0000-000000000000	231	g7pikwyf52gl	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-20 15:13:36.025284+00	2026-02-20 15:13:36.025284+00	\N	f0a9cb41-bd22-41f3-ad47-75d396686025
00000000-0000-0000-0000-000000000000	250	5mgn75biv4ae	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-22 09:50:04.997345+00	2026-02-23 07:05:06.251571+00	\N	2eacbbb8-8773-410f-ad1a-a708a5e3ef29
00000000-0000-0000-0000-000000000000	220	vmruvxsdasxz	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-20 12:49:51.69399+00	2026-02-20 15:23:48.457062+00	cn7ka3y3ogm4	5501bda7-4d4b-4afc-a8b7-0921399db3e9
00000000-0000-0000-0000-000000000000	727	avmbscw4vanw	da0ff70f-fb32-418b-b84f-f66d7fcf6685	f	2026-03-06 16:03:28.236172+00	2026-03-06 16:03:28.236172+00	\N	885eb734-1be1-4749-b690-15d49b7bf830
00000000-0000-0000-0000-000000000000	234	63tudxvvjsdm	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-20 15:25:41.556892+00	2026-02-20 15:25:41.556892+00	\N	e4f2bcd3-0450-400d-b1de-9b29d0728b66
00000000-0000-0000-0000-000000000000	235	dsxzmlqss7sr	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-20 15:35:39.720079+00	2026-02-20 15:35:39.720079+00	\N	344c9d75-8c3b-4f31-80d8-abee28b3826b
00000000-0000-0000-0000-000000000000	236	kvrcmaeqz656	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-20 15:36:56.667442+00	2026-02-20 15:36:56.667442+00	\N	5b8f3689-ea63-4b78-87a7-1954b9511d2c
00000000-0000-0000-0000-000000000000	237	nx4karnsyocz	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-20 15:37:08.546782+00	2026-02-20 15:37:08.546782+00	\N	cc1ccc9a-c570-46a9-b3b8-2404ae2a26f0
00000000-0000-0000-0000-000000000000	223	qr35tsk7ptz7	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-20 13:01:36.015172+00	2026-02-20 15:37:24.952601+00	\N	7957ff95-3335-4487-b9e5-a5553f33b644
00000000-0000-0000-0000-000000000000	242	nsbcnplayhp3	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-20 15:38:53.418078+00	2026-02-20 15:38:53.418078+00	niqirdf6qg7b	5c7870be-5b05-4ada-b5a3-b94bfbb75442
00000000-0000-0000-0000-000000000000	255	kv3yelono6x6	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-23 07:05:06.286673+00	2026-02-23 08:20:07.455629+00	5mgn75biv4ae	2eacbbb8-8773-410f-ad1a-a708a5e3ef29
00000000-0000-0000-0000-000000000000	233	dezwrmnuvawj	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-20 15:23:48.461342+00	2026-02-23 09:29:56.79949+00	vmruvxsdasxz	5501bda7-4d4b-4afc-a8b7-0921399db3e9
00000000-0000-0000-0000-000000000000	257	zsfqj77mihqm	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-23 08:20:07.473408+00	2026-02-23 09:32:10.18119+00	kv3yelono6x6	2eacbbb8-8773-410f-ad1a-a708a5e3ef29
00000000-0000-0000-0000-000000000000	238	htlaa56aulyv	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	t	2026-02-20 15:37:21.562155+00	2026-02-23 10:07:54.796879+00	\N	1c4def97-0027-4852-83cd-6a71ffc224af
00000000-0000-0000-0000-000000000000	262	pecdo2dj5nsr	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-23 09:32:10.182289+00	2026-02-23 10:30:21.666614+00	zsfqj77mihqm	2eacbbb8-8773-410f-ad1a-a708a5e3ef29
00000000-0000-0000-0000-000000000000	260	lpxrcf7wiwfe	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-23 09:29:56.799886+00	2026-02-23 10:53:02.997894+00	dezwrmnuvawj	5501bda7-4d4b-4afc-a8b7-0921399db3e9
00000000-0000-0000-0000-000000000000	268	qn2b3g3baoi3	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-23 10:53:03.009159+00	2026-02-23 12:16:15.589228+00	lpxrcf7wiwfe	5501bda7-4d4b-4afc-a8b7-0921399db3e9
00000000-0000-0000-0000-000000000000	271	on2m4nklvfmv	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-23 12:16:15.601192+00	2026-02-23 13:14:18.813344+00	qn2b3g3baoi3	5501bda7-4d4b-4afc-a8b7-0921399db3e9
00000000-0000-0000-0000-000000000000	241	473wka7c67hi	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-20 15:38:05.141977+00	2026-02-23 18:03:37.703293+00	\N	ed2bc9ce-96ce-4c37-a9d0-765f91b64780
00000000-0000-0000-0000-000000000000	671	evvihjzfitst	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-05 11:57:07.199801+00	2026-03-05 12:55:22.568088+00	oy2yovmd6gbv	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	728	nyp5np52ppvr	b6ccc057-3ea9-4e5f-89b0-d28e37acb208	f	2026-03-06 16:05:08.991499+00	2026-03-06 16:05:08.991499+00	\N	f9ce0ceb-73af-4d0f-812d-349b2f0d17fb
00000000-0000-0000-0000-000000000000	842	r6ijcevhggnh	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-03-10 17:43:00.316996+00	2026-03-10 17:43:00.316996+00	lkmgpoiuj2zv	2673a89a-f8aa-4f8c-bd64-b2de217640d9
00000000-0000-0000-0000-000000000000	274	um2lsk7ye7vg	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-23 13:14:18.826146+00	2026-02-23 16:26:15.453186+00	on2m4nklvfmv	5501bda7-4d4b-4afc-a8b7-0921399db3e9
00000000-0000-0000-0000-000000000000	281	l5ix7m6iolyw	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-23 16:26:15.47245+00	2026-02-23 17:55:31.666878+00	um2lsk7ye7vg	5501bda7-4d4b-4afc-a8b7-0921399db3e9
00000000-0000-0000-0000-000000000000	283	gahlow2ayvq3	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-23 17:55:31.685345+00	2026-02-23 17:55:31.685345+00	l5ix7m6iolyw	5501bda7-4d4b-4afc-a8b7-0921399db3e9
00000000-0000-0000-0000-000000000000	284	kid3yjuhmhd3	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-23 18:03:37.709076+00	2026-02-23 18:03:37.709076+00	473wka7c67hi	ed2bc9ce-96ce-4c37-a9d0-765f91b64780
00000000-0000-0000-0000-000000000000	286	wcdavbpjrses	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-23 18:15:27.324975+00	2026-02-23 18:15:27.324975+00	\N	8d55a955-6f7f-494f-88e6-7d278675097d
00000000-0000-0000-0000-000000000000	285	jtjn5smmbj3c	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-23 18:04:42.645652+00	2026-02-23 19:03:01.784955+00	\N	e2523bd1-ce69-4dcf-a45d-c4678ddfff29
00000000-0000-0000-0000-000000000000	287	btubwr4w6sby	306b5d39-a4ee-4848-a64a-01ad4ffa241d	t	2026-02-23 18:22:11.893324+00	2026-02-24 06:57:42.637716+00	\N	57e7fc31-cf70-4613-a2fe-8a7b4e57607f
00000000-0000-0000-0000-000000000000	289	rolvhdi3oj25	306b5d39-a4ee-4848-a64a-01ad4ffa241d	f	2026-02-24 06:57:42.668007+00	2026-02-24 06:57:42.668007+00	btubwr4w6sby	57e7fc31-cf70-4613-a2fe-8a7b4e57607f
00000000-0000-0000-0000-000000000000	290	pa7a2qhdg2qg	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-24 07:24:01.870396+00	2026-02-24 08:22:01.348042+00	\N	e112cbc6-dbdb-46ab-aee6-92d6a5cffc18
00000000-0000-0000-0000-000000000000	293	maupma2fc4sb	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-24 08:22:01.360179+00	2026-02-24 09:25:36.364026+00	pa7a2qhdg2qg	e112cbc6-dbdb-46ab-aee6-92d6a5cffc18
00000000-0000-0000-0000-000000000000	296	df6wem6o3f7y	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-24 09:25:36.392696+00	2026-02-24 11:54:49.21918+00	maupma2fc4sb	e112cbc6-dbdb-46ab-aee6-92d6a5cffc18
00000000-0000-0000-0000-000000000000	301	7qygh4glptdl	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-24 11:54:49.233352+00	2026-02-24 13:04:56.30124+00	df6wem6o3f7y	e112cbc6-dbdb-46ab-aee6-92d6a5cffc18
00000000-0000-0000-0000-000000000000	304	nf7mwc55t65y	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-24 13:04:56.318348+00	2026-02-24 14:48:00.279129+00	7qygh4glptdl	e112cbc6-dbdb-46ab-aee6-92d6a5cffc18
00000000-0000-0000-0000-000000000000	309	c6advfrojyzw	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-24 14:48:00.29196+00	2026-02-24 16:31:12.767053+00	nf7mwc55t65y	e112cbc6-dbdb-46ab-aee6-92d6a5cffc18
00000000-0000-0000-0000-000000000000	288	ghqjclzyb3vc	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-23 19:03:01.815636+00	2026-02-24 17:12:17.579183+00	jtjn5smmbj3c	e2523bd1-ce69-4dcf-a45d-c4678ddfff29
00000000-0000-0000-0000-000000000000	314	v5oo45s2jvxd	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-24 17:12:17.598675+00	2026-02-24 17:12:17.598675+00	ghqjclzyb3vc	e2523bd1-ce69-4dcf-a45d-c4678ddfff29
00000000-0000-0000-0000-000000000000	315	urxy6f337fgg	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-24 17:12:18.628207+00	2026-02-24 17:12:18.628207+00	\N	6761dae3-442b-4a0c-8e78-2613a27fd90e
00000000-0000-0000-0000-000000000000	312	vzgpp5hkglft	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-24 16:31:12.778738+00	2026-02-24 17:29:11.064604+00	c6advfrojyzw	e112cbc6-dbdb-46ab-aee6-92d6a5cffc18
00000000-0000-0000-0000-000000000000	316	eftfshpkzlip	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-24 17:18:15.941097+00	2026-02-24 18:19:26.972281+00	\N	2edb42f5-9060-4358-8ad0-e9dd8e5e6a8e
00000000-0000-0000-0000-000000000000	318	jqz37cty4cnp	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-24 18:19:26.998303+00	2026-02-24 18:19:26.998303+00	eftfshpkzlip	2edb42f5-9060-4358-8ad0-e9dd8e5e6a8e
00000000-0000-0000-0000-000000000000	319	cgjifcg324nk	a1d1c5fa-e722-4251-907c-afd134b085df	f	2026-02-24 18:31:32.845719+00	2026-02-24 18:31:32.845719+00	\N	2045ba4a-9cdb-47ac-b162-4f89b71ccacd
00000000-0000-0000-0000-000000000000	320	2hhglojoomwc	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-24 18:37:18.631564+00	2026-02-24 18:37:18.631564+00	\N	b01b150f-a2a0-49db-a81c-682cd6f320fa
00000000-0000-0000-0000-000000000000	321	ndgbon2fymio	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-24 18:37:32.600228+00	2026-02-24 18:37:32.600228+00	\N	d470f314-dba7-4cdb-8c32-59e4c59d63d8
00000000-0000-0000-0000-000000000000	322	llbzsx3v4pt2	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-24 18:41:09.409443+00	2026-02-24 18:41:09.409443+00	\N	aafc6906-34ce-4925-9049-8f82b504da47
00000000-0000-0000-0000-000000000000	317	2mrwpfxu27lm	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-24 17:29:11.078097+00	2026-02-24 19:16:54.6459+00	vzgpp5hkglft	e112cbc6-dbdb-46ab-aee6-92d6a5cffc18
00000000-0000-0000-0000-000000000000	323	jwfvh654jknm	a1d1c5fa-e722-4251-907c-afd134b085df	t	2026-02-24 18:57:49.213651+00	2026-02-24 19:56:09.367011+00	\N	67855094-e439-490c-82a2-3b1a60dfa484
00000000-0000-0000-0000-000000000000	324	rv2ayhxxpri6	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-24 19:16:54.668646+00	2026-02-24 21:05:11.665954+00	2mrwpfxu27lm	e112cbc6-dbdb-46ab-aee6-92d6a5cffc18
00000000-0000-0000-0000-000000000000	325	faerv3q6yaqi	a1d1c5fa-e722-4251-907c-afd134b085df	t	2026-02-24 19:56:09.379969+00	2026-02-24 21:09:12.708625+00	jwfvh654jknm	67855094-e439-490c-82a2-3b1a60dfa484
00000000-0000-0000-0000-000000000000	326	76qoej6dy4gg	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-24 21:05:11.681354+00	2026-02-25 07:24:20.957136+00	rv2ayhxxpri6	e112cbc6-dbdb-46ab-aee6-92d6a5cffc18
00000000-0000-0000-0000-000000000000	331	dbs7nqbyfmjn	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-25 07:24:20.974752+00	2026-02-25 07:24:20.974752+00	76qoej6dy4gg	e112cbc6-dbdb-46ab-aee6-92d6a5cffc18
00000000-0000-0000-0000-000000000000	327	nf67ifuz5oo3	a1d1c5fa-e722-4251-907c-afd134b085df	t	2026-02-24 21:09:12.709404+00	2026-02-25 07:59:26.756495+00	faerv3q6yaqi	67855094-e439-490c-82a2-3b1a60dfa484
00000000-0000-0000-0000-000000000000	334	vkustduxhtk3	a1d1c5fa-e722-4251-907c-afd134b085df	f	2026-02-25 07:59:26.757543+00	2026-02-25 07:59:26.757543+00	nf67ifuz5oo3	67855094-e439-490c-82a2-3b1a60dfa484
00000000-0000-0000-0000-000000000000	335	kl7dfftkdy6y	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-25 08:09:27.470731+00	2026-02-25 08:09:27.470731+00	\N	1fc95765-74be-4a05-87dc-9d9ef84138b3
00000000-0000-0000-0000-000000000000	336	whqii7nrm7vu	a1d1c5fa-e722-4251-907c-afd134b085df	f	2026-02-25 08:13:12.905704+00	2026-02-25 08:13:12.905704+00	\N	110072b5-f096-4131-b3bf-ce4cb10a007f
00000000-0000-0000-0000-000000000000	337	zzlvkhwznbc4	d071f9b2-ce73-44a2-b015-2a2d8efe1503	f	2026-02-25 08:13:43.06553+00	2026-02-25 08:13:43.06553+00	\N	6f000ef3-6fdc-4366-a41a-761ad44db9d6
00000000-0000-0000-0000-000000000000	338	pktjiwuf5gov	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	f	2026-02-25 08:15:48.710516+00	2026-02-25 08:15:48.710516+00	\N	70decc67-f748-4257-8c23-f294ec203927
00000000-0000-0000-0000-000000000000	339	mxdjxvqzsqvw	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-25 08:17:08.086944+00	2026-02-25 08:17:08.086944+00	\N	64984977-ccd2-48d4-95db-51e916e1c775
00000000-0000-0000-0000-000000000000	341	xxiij4wxp6zi	a1d1c5fa-e722-4251-907c-afd134b085df	f	2026-02-25 08:18:54.672376+00	2026-02-25 08:18:54.672376+00	\N	7c048b83-087a-4efd-a751-ac714bc7979e
00000000-0000-0000-0000-000000000000	340	cnha66xm5rfw	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 08:17:23.451227+00	2026-02-25 09:15:32.128896+00	\N	71744bbf-6091-4e4c-b1f3-7e0261159857
00000000-0000-0000-0000-000000000000	342	7p2wd2gbodzd	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 08:23:46.378141+00	2026-02-25 09:45:32.895836+00	\N	f032bc4d-e36e-4f8e-bb95-e107cd5f421a
00000000-0000-0000-0000-000000000000	345	vwls66rfhnhe	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 09:15:32.144273+00	2026-02-25 10:15:45.336366+00	cnha66xm5rfw	71744bbf-6091-4e4c-b1f3-7e0261159857
00000000-0000-0000-0000-000000000000	347	cht7jjaufbcl	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 09:45:32.917747+00	2026-02-25 10:43:51.536812+00	7p2wd2gbodzd	f032bc4d-e36e-4f8e-bb95-e107cd5f421a
00000000-0000-0000-0000-000000000000	351	cloouvmimscz	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 10:43:51.562145+00	2026-02-25 11:41:53.949815+00	cht7jjaufbcl	f032bc4d-e36e-4f8e-bb95-e107cd5f421a
00000000-0000-0000-0000-000000000000	349	2ciet2esovcr	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 10:15:45.344959+00	2026-02-25 11:45:19.93479+00	vwls66rfhnhe	71744bbf-6091-4e4c-b1f3-7e0261159857
00000000-0000-0000-0000-000000000000	354	enrhroijwxro	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 11:41:53.957009+00	2026-02-25 12:39:54.00775+00	cloouvmimscz	f032bc4d-e36e-4f8e-bb95-e107cd5f421a
00000000-0000-0000-0000-000000000000	355	axwlrpn64thd	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 11:45:19.94609+00	2026-02-25 13:08:56.617414+00	2ciet2esovcr	71744bbf-6091-4e4c-b1f3-7e0261159857
00000000-0000-0000-0000-000000000000	356	fpjuvid3gjzf	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 12:39:54.019148+00	2026-02-25 13:42:40.867643+00	enrhroijwxro	f032bc4d-e36e-4f8e-bb95-e107cd5f421a
00000000-0000-0000-0000-000000000000	359	wiyhk5xqkxcm	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 13:08:56.628891+00	2026-02-25 14:07:28.678579+00	axwlrpn64thd	71744bbf-6091-4e4c-b1f3-7e0261159857
00000000-0000-0000-0000-000000000000	361	wqx4kjeifzxi	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 13:42:40.868706+00	2026-02-25 14:40:50.814183+00	fpjuvid3gjzf	f032bc4d-e36e-4f8e-bb95-e107cd5f421a
00000000-0000-0000-0000-000000000000	363	2inoieyincxb	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 14:07:28.687581+00	2026-02-25 15:05:44.80495+00	wiyhk5xqkxcm	71744bbf-6091-4e4c-b1f3-7e0261159857
00000000-0000-0000-0000-000000000000	365	jk3wmmbe7tpf	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 14:40:50.814588+00	2026-02-25 15:39:20.021657+00	wqx4kjeifzxi	f032bc4d-e36e-4f8e-bb95-e107cd5f421a
00000000-0000-0000-0000-000000000000	367	yv7oetch33wi	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 15:05:44.825203+00	2026-02-25 16:04:12.733684+00	2inoieyincxb	71744bbf-6091-4e4c-b1f3-7e0261159857
00000000-0000-0000-0000-000000000000	369	ali2ellym5oo	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 15:39:20.022623+00	2026-02-25 16:37:29.466557+00	jk3wmmbe7tpf	f032bc4d-e36e-4f8e-bb95-e107cd5f421a
00000000-0000-0000-0000-000000000000	370	md3cwxodkrg3	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 16:04:12.754967+00	2026-02-25 17:02:42.458417+00	yv7oetch33wi	71744bbf-6091-4e4c-b1f3-7e0261159857
00000000-0000-0000-0000-000000000000	372	42zrggouix5q	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 16:37:29.466945+00	2026-02-25 17:38:28.89532+00	ali2ellym5oo	f032bc4d-e36e-4f8e-bb95-e107cd5f421a
00000000-0000-0000-0000-000000000000	388	kclp6xhtggni	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-26 06:25:14.527932+00	2026-02-26 07:23:27.416883+00	lq23xv3swhwh	976500e2-0416-4d6a-9c2f-e0930e762dcb
00000000-0000-0000-0000-000000000000	382	qanwteezym7k	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-25 21:10:19.106407+00	2026-02-26 07:58:51.059133+00	\N	2046e76d-2c8a-42ff-8b3d-457716c373b1
00000000-0000-0000-0000-000000000000	373	qwv25y7q4q6y	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 17:02:42.476268+00	2026-02-25 18:36:58.43439+00	md3cwxodkrg3	71744bbf-6091-4e4c-b1f3-7e0261159857
00000000-0000-0000-0000-000000000000	374	xlyyq6mcpdp2	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 17:38:28.90766+00	2026-02-25 18:52:31.785345+00	42zrggouix5q	f032bc4d-e36e-4f8e-bb95-e107cd5f421a
00000000-0000-0000-0000-000000000000	375	eckixlwftvh4	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 18:36:58.450855+00	2026-02-25 19:35:15.802019+00	qwv25y7q4q6y	71744bbf-6091-4e4c-b1f3-7e0261159857
00000000-0000-0000-0000-000000000000	555	5k6vayl6j2du	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-03 07:29:25.658329+00	2026-03-03 08:27:44.291916+00	5bjlxkjvp5n7	e2ebfcc8-56fe-435a-86cc-3966a8b2b9ea
00000000-0000-0000-0000-000000000000	376	tywwlzh6sts7	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 18:52:31.794143+00	2026-02-25 20:00:25.722783+00	xlyyq6mcpdp2	f032bc4d-e36e-4f8e-bb95-e107cd5f421a
00000000-0000-0000-0000-000000000000	390	uuz5zxkemjlg	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-26 07:23:27.429257+00	2026-02-26 08:58:33.451238+00	kclp6xhtggni	976500e2-0416-4d6a-9c2f-e0930e762dcb
00000000-0000-0000-0000-000000000000	688	clmgw7xrcmjq	21f90788-2d49-4547-b867-d52455e0d56b	f	2026-03-05 19:09:07.510361+00	2026-03-05 19:09:07.510361+00	\N	8f6947bd-d612-40f0-85e7-f33c03b6025b
00000000-0000-0000-0000-000000000000	377	3t2zyr4pyk7s	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 19:35:15.822213+00	2026-02-25 20:36:02.986138+00	eckixlwftvh4	71744bbf-6091-4e4c-b1f3-7e0261159857
00000000-0000-0000-0000-000000000000	378	6djrc2yrin3i	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 20:00:25.735075+00	2026-02-25 20:58:29.059601+00	tywwlzh6sts7	f032bc4d-e36e-4f8e-bb95-e107cd5f421a
00000000-0000-0000-0000-000000000000	381	ssnbhgepjlpv	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-25 20:58:29.065961+00	2026-02-25 20:58:29.065961+00	6djrc2yrin3i	f032bc4d-e36e-4f8e-bb95-e107cd5f421a
00000000-0000-0000-0000-000000000000	380	o7wacwrjlltc	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 20:36:03.008527+00	2026-02-25 21:56:27.249067+00	3t2zyr4pyk7s	71744bbf-6091-4e4c-b1f3-7e0261159857
00000000-0000-0000-0000-000000000000	383	nyvizn7f5g7b	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-25 21:56:27.275069+00	2026-02-25 21:56:27.275069+00	o7wacwrjlltc	71744bbf-6091-4e4c-b1f3-7e0261159857
00000000-0000-0000-0000-000000000000	384	hcvbyn33i7pu	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-25 21:59:35.187565+00	2026-02-25 21:59:35.187565+00	\N	c49cc55d-fcb6-43dd-b601-492199c658ee
00000000-0000-0000-0000-000000000000	385	3pc3fnvwy5a6	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	f	2026-02-25 22:00:26.246524+00	2026-02-25 22:00:26.246524+00	\N	b4fdae1e-0386-4c68-a285-d5747b202472
00000000-0000-0000-0000-000000000000	386	lq23xv3swhwh	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-25 22:00:50.967985+00	2026-02-26 06:25:14.521085+00	\N	976500e2-0416-4d6a-9c2f-e0930e762dcb
00000000-0000-0000-0000-000000000000	802	tzvvrik5jghm	092175d3-fa6b-4b6d-9a62-67a547151b5c	f	2026-03-09 10:23:51.761309+00	2026-03-09 10:23:51.761309+00	\N	2fd777ec-6d8c-4f12-b553-6fad05fb2053
00000000-0000-0000-0000-000000000000	395	yjyqsm5hcfcs	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-26 08:58:33.453935+00	2026-02-26 09:56:30.577774+00	uuz5zxkemjlg	976500e2-0416-4d6a-9c2f-e0930e762dcb
00000000-0000-0000-0000-000000000000	392	cz77nbg2phc6	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-26 07:58:51.062258+00	2026-02-26 09:58:58.993616+00	qanwteezym7k	2046e76d-2c8a-42ff-8b3d-457716c373b1
00000000-0000-0000-0000-000000000000	398	v6zwbvlnzaad	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-26 09:56:30.594067+00	2026-02-26 11:01:35.304719+00	yjyqsm5hcfcs	976500e2-0416-4d6a-9c2f-e0930e762dcb
00000000-0000-0000-0000-000000000000	402	o7smgqkg56vo	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-26 11:01:35.313151+00	2026-02-26 12:37:05.081188+00	v6zwbvlnzaad	976500e2-0416-4d6a-9c2f-e0930e762dcb
00000000-0000-0000-0000-000000000000	406	rymrfrljycap	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-26 12:37:05.089009+00	2026-02-26 13:36:29.89323+00	o7smgqkg56vo	976500e2-0416-4d6a-9c2f-e0930e762dcb
00000000-0000-0000-0000-000000000000	409	tozrhanj7lqc	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-26 13:36:29.913404+00	2026-02-26 15:00:32.775199+00	rymrfrljycap	976500e2-0416-4d6a-9c2f-e0930e762dcb
00000000-0000-0000-0000-000000000000	412	ikgc2tqw4dn7	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-26 15:00:32.807931+00	2026-02-26 15:59:40.678131+00	tozrhanj7lqc	976500e2-0416-4d6a-9c2f-e0930e762dcb
00000000-0000-0000-0000-000000000000	415	b252e3nwoylc	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-26 15:59:40.690043+00	2026-02-26 17:42:47.176307+00	ikgc2tqw4dn7	976500e2-0416-4d6a-9c2f-e0930e762dcb
00000000-0000-0000-0000-000000000000	418	5zt66qnjug6h	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-26 17:42:47.200728+00	2026-02-26 19:16:15.60869+00	b252e3nwoylc	976500e2-0416-4d6a-9c2f-e0930e762dcb
00000000-0000-0000-0000-000000000000	420	fvfjs5rdsmva	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-26 19:16:15.631182+00	2026-02-26 20:15:03.822675+00	5zt66qnjug6h	976500e2-0416-4d6a-9c2f-e0930e762dcb
00000000-0000-0000-0000-000000000000	421	iczflraxngvu	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-26 20:15:03.839962+00	2026-02-26 22:31:11.625532+00	fvfjs5rdsmva	976500e2-0416-4d6a-9c2f-e0930e762dcb
00000000-0000-0000-0000-000000000000	422	dl7cafwbjfud	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-26 22:31:11.659692+00	2026-02-27 07:28:57.534331+00	iczflraxngvu	976500e2-0416-4d6a-9c2f-e0930e762dcb
00000000-0000-0000-0000-000000000000	399	5fpu5amhzsx6	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-26 09:58:58.99472+00	2026-02-27 12:16:05.253236+00	cz77nbg2phc6	2046e76d-2c8a-42ff-8b3d-457716c373b1
00000000-0000-0000-0000-000000000000	674	4buchk7snbq2	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-05 12:37:18.797618+00	2026-03-05 15:04:04.460694+00	\N	fa6fcc8c-6d2e-41f5-8425-eda1e998bbf9
00000000-0000-0000-0000-000000000000	689	th26evimnmgv	8642c8b5-f0b9-4811-8f7a-425155de9d1d	f	2026-03-05 19:12:42.340689+00	2026-03-05 19:12:42.340689+00	\N	f1d869fa-7f2b-48f3-b7ae-eb60042e4883
00000000-0000-0000-0000-000000000000	425	nahzw3brzmhh	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-27 07:28:57.546934+00	2026-02-27 07:28:57.546934+00	dl7cafwbjfud	976500e2-0416-4d6a-9c2f-e0930e762dcb
00000000-0000-0000-0000-000000000000	787	mpdpm7f3iloa	924c7e03-fc42-479c-b841-c7eaa607cdc6	f	2026-03-09 08:09:54.093295+00	2026-03-09 08:09:54.093295+00	\N	ebbbf287-a0ea-4e5c-9a3d-1cf2db0e5865
00000000-0000-0000-0000-000000000000	427	wvl2l2vwjxmk	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-27 07:39:24.146617+00	2026-02-27 08:52:23.114564+00	\N	a8f2d17a-9f44-4da5-842e-bb69317e987c
00000000-0000-0000-0000-000000000000	803	7sfzvakdkzel	73ebb754-d8b0-46d2-bea9-846fa82d3657	f	2026-03-09 10:25:40.968784+00	2026-03-09 10:25:40.968784+00	\N	708bb470-1253-4403-a9a2-bed497029491
00000000-0000-0000-0000-000000000000	816	6xbczweotzc6	217a05cc-7709-4e39-a0cf-ede8b02d87a4	f	2026-03-09 13:48:09.291841+00	2026-03-09 13:48:09.291841+00	\N	04a1446b-a12f-44ab-90d5-08926c52861a
00000000-0000-0000-0000-000000000000	430	azge7xqbjwij	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-27 08:52:23.128578+00	2026-02-27 09:50:44.63292+00	wvl2l2vwjxmk	a8f2d17a-9f44-4da5-842e-bb69317e987c
00000000-0000-0000-0000-000000000000	829	gzsmatu4tlwm	d071f9b2-ce73-44a2-b015-2a2d8efe1503	f	2026-03-10 14:12:46.820494+00	2026-03-10 14:12:46.820494+00	\N	a1964111-fed5-4c31-9a70-6bcc7bc06494
00000000-0000-0000-0000-000000000000	433	j2txe7et5ofv	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-27 09:50:44.638735+00	2026-02-27 11:54:34.493979+00	azge7xqbjwij	a8f2d17a-9f44-4da5-842e-bb69317e987c
00000000-0000-0000-0000-000000000000	439	abv6hfensfdt	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-27 12:16:05.259226+00	2026-02-27 12:16:05.259226+00	5fpu5amhzsx6	2046e76d-2c8a-42ff-8b3d-457716c373b1
00000000-0000-0000-0000-000000000000	437	ab5d3lgiehr6	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-27 11:54:34.511497+00	2026-02-27 12:52:51.521572+00	j2txe7et5ofv	a8f2d17a-9f44-4da5-842e-bb69317e987c
00000000-0000-0000-0000-000000000000	440	nl6yt3s2my5i	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-27 12:16:10.62187+00	2026-02-27 13:36:44.040554+00	\N	541ac0bc-3df8-4dc7-9769-c1246ecdd45c
00000000-0000-0000-0000-000000000000	445	bci75avugcre	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-27 13:36:44.050935+00	2026-02-27 13:36:44.050935+00	nl6yt3s2my5i	541ac0bc-3df8-4dc7-9769-c1246ecdd45c
00000000-0000-0000-0000-000000000000	446	oxc7njfetnmf	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-27 14:02:35.213529+00	2026-02-27 15:00:54.037326+00	\N	a438af8b-7705-44be-b12a-e3fc7aa96314
00000000-0000-0000-0000-000000000000	442	vnhbbhpskak6	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-27 12:52:51.542728+00	2026-02-27 15:07:53.464247+00	ab5d3lgiehr6	a8f2d17a-9f44-4da5-842e-bb69317e987c
00000000-0000-0000-0000-000000000000	449	utl3xk2e5fg6	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-27 15:00:54.052637+00	2026-02-27 15:59:03.726563+00	oxc7njfetnmf	a438af8b-7705-44be-b12a-e3fc7aa96314
00000000-0000-0000-0000-000000000000	451	zxumxe3cj246	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-27 15:07:53.465373+00	2026-02-27 16:32:47.429306+00	vnhbbhpskak6	a8f2d17a-9f44-4da5-842e-bb69317e987c
00000000-0000-0000-0000-000000000000	452	7jabxg6n45mt	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-27 15:59:03.742164+00	2026-02-27 16:57:13.117786+00	utl3xk2e5fg6	a438af8b-7705-44be-b12a-e3fc7aa96314
00000000-0000-0000-0000-000000000000	453	kebtb47uf3gk	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-27 16:32:47.438951+00	2026-02-27 17:30:48.755055+00	zxumxe3cj246	a8f2d17a-9f44-4da5-842e-bb69317e987c
00000000-0000-0000-0000-000000000000	455	oghlhsxrdyj5	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-27 17:30:48.769926+00	2026-02-27 18:31:07.484072+00	kebtb47uf3gk	a8f2d17a-9f44-4da5-842e-bb69317e987c
00000000-0000-0000-0000-000000000000	454	ephgrkomygov	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-27 16:57:13.131511+00	2026-02-27 18:43:37.319223+00	7jabxg6n45mt	a438af8b-7705-44be-b12a-e3fc7aa96314
00000000-0000-0000-0000-000000000000	457	qpgf4f7ushhx	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-27 18:31:07.49971+00	2026-02-27 19:29:30.049792+00	oghlhsxrdyj5	a8f2d17a-9f44-4da5-842e-bb69317e987c
00000000-0000-0000-0000-000000000000	458	tkpw3eiup3rb	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-27 18:43:37.329254+00	2026-02-27 20:06:20.342205+00	ephgrkomygov	a438af8b-7705-44be-b12a-e3fc7aa96314
00000000-0000-0000-0000-000000000000	460	q6q5ltrwyhn3	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-27 19:29:30.059686+00	2026-02-27 20:27:54.986029+00	qpgf4f7ushhx	a8f2d17a-9f44-4da5-842e-bb69317e987c
00000000-0000-0000-0000-000000000000	462	wjulfwb6ndv2	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-27 20:27:54.999431+00	2026-02-27 20:27:54.999431+00	q6q5ltrwyhn3	a8f2d17a-9f44-4da5-842e-bb69317e987c
00000000-0000-0000-0000-000000000000	461	llztlgd6uli7	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-27 20:06:20.36339+00	2026-02-27 21:35:45.210435+00	tkpw3eiup3rb	a438af8b-7705-44be-b12a-e3fc7aa96314
00000000-0000-0000-0000-000000000000	464	s32csr5qlxxr	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-27 21:35:45.233979+00	2026-02-27 22:34:00.877953+00	llztlgd6uli7	a438af8b-7705-44be-b12a-e3fc7aa96314
00000000-0000-0000-0000-000000000000	465	e6jdrayleyvs	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-27 22:34:00.907144+00	2026-02-27 23:32:07.964842+00	s32csr5qlxxr	a438af8b-7705-44be-b12a-e3fc7aa96314
00000000-0000-0000-0000-000000000000	463	xjlyokybypsm	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-27 21:11:11.019236+00	2026-02-28 08:46:05.016375+00	\N	b0d3a4c7-121f-42b8-8ef6-09c519fd2068
00000000-0000-0000-0000-000000000000	467	sys3pa3nel6j	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-28 08:46:05.051589+00	2026-02-28 10:30:50.0901+00	xjlyokybypsm	b0d3a4c7-121f-42b8-8ef6-09c519fd2068
00000000-0000-0000-0000-000000000000	468	byfgmjynebi7	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-28 10:30:50.104113+00	2026-02-28 11:29:04.182154+00	sys3pa3nel6j	b0d3a4c7-121f-42b8-8ef6-09c519fd2068
00000000-0000-0000-0000-000000000000	466	ytfzjiugelnc	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-27 23:32:07.978294+00	2026-02-28 11:57:25.21043+00	e6jdrayleyvs	a438af8b-7705-44be-b12a-e3fc7aa96314
00000000-0000-0000-0000-000000000000	471	xrqqqzdmu42s	c4ec5e93-766d-48c2-8312-8c673287fbd9	f	2026-02-28 11:57:25.225604+00	2026-02-28 11:57:25.225604+00	ytfzjiugelnc	a438af8b-7705-44be-b12a-e3fc7aa96314
00000000-0000-0000-0000-000000000000	469	4b5t74vsc6ze	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-28 11:29:04.209441+00	2026-02-28 13:03:51.454034+00	byfgmjynebi7	b0d3a4c7-121f-42b8-8ef6-09c519fd2068
00000000-0000-0000-0000-000000000000	472	6v6vt4e2gbxf	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-28 11:57:26.344433+00	2026-02-28 13:12:32.796813+00	\N	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	675	vrvswkmanvu5	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-05 12:55:22.582386+00	2026-03-05 13:53:24.305874+00	evvihjzfitst	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	473	rzcpin74ocdm	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-28 13:03:51.47152+00	2026-02-28 14:01:51.046675+00	4b5t74vsc6ze	b0d3a4c7-121f-42b8-8ef6-09c519fd2068
00000000-0000-0000-0000-000000000000	474	xpbfqj34fh4k	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-28 13:12:32.797681+00	2026-02-28 14:10:46.020325+00	6v6vt4e2gbxf	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	476	dv3du7bmgwuo	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-28 14:10:46.022454+00	2026-02-28 15:08:47.646007+00	xpbfqj34fh4k	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	477	bgz3t5caq7ae	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-28 15:08:47.660825+00	2026-02-28 16:06:50.278908+00	dv3du7bmgwuo	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	475	kbj6l7vcnil2	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-28 14:01:51.073649+00	2026-02-28 16:29:29.907638+00	rzcpin74ocdm	b0d3a4c7-121f-42b8-8ef6-09c519fd2068
00000000-0000-0000-0000-000000000000	479	tlwq5pe7qv3d	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-02-28 16:29:29.925096+00	2026-02-28 16:29:29.925096+00	kbj6l7vcnil2	b0d3a4c7-121f-42b8-8ef6-09c519fd2068
00000000-0000-0000-0000-000000000000	478	7hvjh3lj7std	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-28 16:06:50.305587+00	2026-02-28 17:09:59.703596+00	bgz3t5caq7ae	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	804	qsv4jsik34ny	b0187f61-fe65-436d-a9f8-dc1a2b4d307e	f	2026-03-09 10:27:30.567655+00	2026-03-09 10:27:30.567655+00	\N	ac0c7844-3e23-45c4-8226-1bfb88c36ddc
00000000-0000-0000-0000-000000000000	480	up3kx35te6n5	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-28 16:29:35.391219+00	2026-02-28 17:28:00.25879+00	\N	ba9b8494-24b3-4931-ac1c-56f39c89173b
00000000-0000-0000-0000-000000000000	481	fnt5x7u6xcku	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-28 17:09:59.714047+00	2026-02-28 18:57:22.978514+00	7hvjh3lj7std	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	482	lclm3mikyhoy	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-28 17:28:00.267407+00	2026-02-28 19:38:30.446503+00	up3kx35te6n5	ba9b8494-24b3-4931-ac1c-56f39c89173b
00000000-0000-0000-0000-000000000000	485	hqbi2ttygyve	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-28 18:57:22.99415+00	2026-02-28 19:55:37.317698+00	fnt5x7u6xcku	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	487	guvngffnz57h	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-28 19:38:30.456889+00	2026-02-28 20:36:30.465739+00	lclm3mikyhoy	ba9b8494-24b3-4931-ac1c-56f39c89173b
00000000-0000-0000-0000-000000000000	488	yjqjpxutatts	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-28 19:55:37.343818+00	2026-02-28 20:55:27.365556+00	hqbi2ttygyve	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	490	nsncvm5zpnoo	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-28 20:55:27.373046+00	2026-02-28 21:53:56.626024+00	yjqjpxutatts	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	491	7yfhuxvuwf4j	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-28 21:53:56.643989+00	2026-02-28 22:52:17.482162+00	nsncvm5zpnoo	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	489	ywru4jcvgzgt	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-28 20:36:30.490708+00	2026-03-01 07:57:18.203923+00	guvngffnz57h	ba9b8494-24b3-4931-ac1c-56f39c89173b
00000000-0000-0000-0000-000000000000	494	cwkundvt2zhc	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-03-01 07:57:18.209793+00	2026-03-01 07:57:18.209793+00	ywru4jcvgzgt	ba9b8494-24b3-4931-ac1c-56f39c89173b
00000000-0000-0000-0000-000000000000	492	5im7rreitgve	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-02-28 22:52:17.512073+00	2026-03-01 10:23:15.440466+00	7yfhuxvuwf4j	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	495	h4rohlsiudyg	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-01 07:57:28.635955+00	2026-03-01 10:45:53.287342+00	\N	e2ebfcc8-56fe-435a-86cc-3966a8b2b9ea
00000000-0000-0000-0000-000000000000	498	yybdmtqefpcb	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-01 10:45:53.306476+00	2026-03-01 11:44:08.979465+00	h4rohlsiudyg	e2ebfcc8-56fe-435a-86cc-3966a8b2b9ea
00000000-0000-0000-0000-000000000000	497	uucqfbp77o66	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-01 10:23:15.460595+00	2026-03-01 12:10:55.107343+00	5im7rreitgve	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	502	ziboomfzfesa	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-01 12:10:55.120696+00	2026-03-01 14:27:39.512955+00	uucqfbp77o66	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	500	krn42zb5rlxt	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-01 11:44:08.995647+00	2026-03-01 15:14:58.088003+00	yybdmtqefpcb	e2ebfcc8-56fe-435a-86cc-3966a8b2b9ea
00000000-0000-0000-0000-000000000000	504	j5dukbbo4cgx	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-01 14:27:39.533415+00	2026-03-01 15:25:58.768032+00	ziboomfzfesa	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	507	mbue4urlqktg	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-01 15:25:58.783704+00	2026-03-01 16:24:14.64039+00	j5dukbbo4cgx	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	506	6xvjnt4hoang	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-01 15:14:58.104699+00	2026-03-01 16:56:22.725728+00	krn42zb5rlxt	e2ebfcc8-56fe-435a-86cc-3966a8b2b9ea
00000000-0000-0000-0000-000000000000	508	3jsz4fo4mttq	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-01 16:24:14.667518+00	2026-03-01 17:22:58.706553+00	mbue4urlqktg	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	509	6qgsehqj3eyc	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-01 16:56:22.741325+00	2026-03-01 18:19:13.230272+00	6xvjnt4hoang	e2ebfcc8-56fe-435a-86cc-3966a8b2b9ea
00000000-0000-0000-0000-000000000000	511	sgzij6jxcdcr	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-01 18:19:13.265055+00	2026-03-01 19:17:12.139389+00	6qgsehqj3eyc	e2ebfcc8-56fe-435a-86cc-3966a8b2b9ea
00000000-0000-0000-0000-000000000000	510	kikavnrbffik	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-01 17:22:58.711431+00	2026-03-01 20:29:28.379668+00	3jsz4fo4mttq	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	513	ql4xci5u3vob	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-01 20:29:28.406016+00	2026-03-01 21:27:39.819907+00	kikavnrbffik	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	514	eisd76sacp6n	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-01 21:27:39.830916+00	2026-03-01 22:25:41.463009+00	ql4xci5u3vob	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	515	4adxmtfht27l	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-01 22:25:41.492296+00	2026-03-01 23:24:07.41719+00	eisd76sacp6n	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	516	5d7olyyrh36b	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-01 23:24:07.429673+00	2026-03-02 00:22:56.518736+00	4adxmtfht27l	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	512	pjqycvrukpm6	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-01 19:17:12.15748+00	2026-03-02 07:04:42.018237+00	sgzij6jxcdcr	e2ebfcc8-56fe-435a-86cc-3966a8b2b9ea
00000000-0000-0000-0000-000000000000	519	5unwpk76i7xr	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-02 07:04:42.046376+00	2026-03-02 08:02:48.725795+00	pjqycvrukpm6	e2ebfcc8-56fe-435a-86cc-3966a8b2b9ea
00000000-0000-0000-0000-000000000000	517	ajf6dyi4ctja	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-02 00:22:56.540528+00	2026-03-02 09:56:46.855493+00	5d7olyyrh36b	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	522	drkuzeoixo3d	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-02 08:02:48.72796+00	2026-03-02 10:02:18.315013+00	5unwpk76i7xr	e2ebfcc8-56fe-435a-86cc-3966a8b2b9ea
00000000-0000-0000-0000-000000000000	551	l6jrna2pzsk5	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-03 01:13:36.138694+00	2026-03-03 02:12:03.985371+00	prqv7mafisde	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	546	5bjlxkjvp5n7	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-02 19:00:27.17594+00	2026-03-03 07:29:25.654513+00	adznkfrmt4bk	e2ebfcc8-56fe-435a-86cc-3966a8b2b9ea
00000000-0000-0000-0000-000000000000	805	ynrwmli76sj7	1c0f7c19-3851-4429-91c9-6b8d67d4e7b7	f	2026-03-09 10:32:02.824194+00	2026-03-09 10:32:02.824194+00	\N	3f281e0e-1cb9-4915-9604-9228e198e9f5
00000000-0000-0000-0000-000000000000	556	od7wwmxuzvsd	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-03 08:27:44.314108+00	2026-03-03 09:33:51.354618+00	5k6vayl6j2du	e2ebfcc8-56fe-435a-86cc-3966a8b2b9ea
00000000-0000-0000-0000-000000000000	527	uqcdp5tbflqk	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-02 10:02:18.3173+00	2026-03-02 11:00:21.791618+00	drkuzeoixo3d	e2ebfcc8-56fe-435a-86cc-3966a8b2b9ea
00000000-0000-0000-0000-000000000000	526	ve4mzvoahn3f	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-02 09:56:46.859171+00	2026-03-02 11:01:57.814244+00	ajf6dyi4ctja	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	833	gqdbc5hitos7	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-10 14:55:13.250633+00	2026-03-10 15:54:22.144344+00	\N	2673a89a-f8aa-4f8c-bd64-b2de217640d9
00000000-0000-0000-0000-000000000000	530	xfysogutrehx	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-02 11:00:21.793952+00	2026-03-02 12:00:08.531046+00	uqcdp5tbflqk	e2ebfcc8-56fe-435a-86cc-3966a8b2b9ea
00000000-0000-0000-0000-000000000000	531	2orf3c3jvclz	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-02 11:01:57.815635+00	2026-03-02 12:34:58.091318+00	ve4mzvoahn3f	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	559	75oqpbvb7ycf	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-03 09:33:51.362029+00	2026-03-03 10:33:36.481609+00	od7wwmxuzvsd	e2ebfcc8-56fe-435a-86cc-3966a8b2b9ea
00000000-0000-0000-0000-000000000000	562	yjsu3islpr7y	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-03-03 10:33:36.483557+00	2026-03-03 10:33:36.483557+00	75oqpbvb7ycf	e2ebfcc8-56fe-435a-86cc-3966a8b2b9ea
00000000-0000-0000-0000-000000000000	534	yiymiwj4ofrj	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-02 12:34:58.10766+00	2026-03-02 13:33:18.868623+00	2orf3c3jvclz	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	537	2kmtjasm7dnu	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-02 13:33:18.874604+00	2026-03-02 14:32:03.871015+00	yiymiwj4ofrj	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	539	2wbg6ky3tgdu	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-02 14:32:03.89225+00	2026-03-02 15:30:08.379092+00	2kmtjasm7dnu	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	542	fsoqdxm3psas	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-02 15:30:08.388371+00	2026-03-02 16:28:16.847537+00	2wbg6ky3tgdu	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	564	tex3xdqdytvn	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-03 10:58:17.383597+00	2026-03-03 12:23:39.094189+00	\N	13fdd596-fd78-4814-b0c7-7ce3260bab71
00000000-0000-0000-0000-000000000000	532	cqxioq5r4ut3	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-02 12:00:08.544882+00	2026-03-02 18:02:01.196681+00	xfysogutrehx	e2ebfcc8-56fe-435a-86cc-3966a8b2b9ea
00000000-0000-0000-0000-000000000000	545	adznkfrmt4bk	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-02 18:02:01.229864+00	2026-03-02 19:00:27.15038+00	cqxioq5r4ut3	e2ebfcc8-56fe-435a-86cc-3966a8b2b9ea
00000000-0000-0000-0000-000000000000	544	fgt5uipikw67	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-02 16:28:16.858806+00	2026-03-02 21:20:58.993402+00	fsoqdxm3psas	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	547	a3urghi6egkx	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-02 21:20:59.014773+00	2026-03-02 22:19:05.013704+00	fgt5uipikw67	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	548	2hdjwbdq3bvv	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-02 22:19:05.038117+00	2026-03-02 23:17:23.450065+00	a3urghi6egkx	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	549	ecqd6rqw2z7a	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-02 23:17:23.475501+00	2026-03-03 00:15:24.137332+00	2hdjwbdq3bvv	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	550	prqv7mafisde	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-03 00:15:24.162665+00	2026-03-03 01:13:36.124262+00	ecqd6rqw2z7a	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	266	geam4gskcacn	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-02-23 10:30:21.682859+00	2026-03-03 12:34:42.965995+00	pecdo2dj5nsr	2eacbbb8-8773-410f-ad1a-a708a5e3ef29
00000000-0000-0000-0000-000000000000	566	dq2fgmu52za6	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-03 12:23:39.121565+00	2026-03-03 13:21:51.427712+00	tex3xdqdytvn	13fdd596-fd78-4814-b0c7-7ce3260bab71
00000000-0000-0000-0000-000000000000	570	4znvz4wvedan	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-03 13:21:51.444201+00	2026-03-03 14:19:49.919336+00	dq2fgmu52za6	13fdd596-fd78-4814-b0c7-7ce3260bab71
00000000-0000-0000-0000-000000000000	552	tzelbpmrskoh	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-03 02:12:04.002319+00	2026-03-03 14:51:07.524702+00	l6jrna2pzsk5	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	573	u5io6m3t6xg2	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-03 14:19:49.932825+00	2026-03-03 15:18:41.97077+00	4znvz4wvedan	13fdd596-fd78-4814-b0c7-7ce3260bab71
00000000-0000-0000-0000-000000000000	569	ivy5xsyblrfb	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-03 12:34:42.982666+00	2026-03-03 17:26:12.853067+00	geam4gskcacn	2eacbbb8-8773-410f-ad1a-a708a5e3ef29
00000000-0000-0000-0000-000000000000	677	kmtar4kc5gcz	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-05 13:53:24.330281+00	2026-03-05 14:53:36.299797+00	vrvswkmanvu5	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	576	vsbzr2uhhdvz	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-03 15:18:41.985487+00	2026-03-03 16:16:41.671909+00	u5io6m3t6xg2	13fdd596-fd78-4814-b0c7-7ce3260bab71
00000000-0000-0000-0000-000000000000	578	vttwr2ppkdan	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-03 16:16:41.696629+00	2026-03-03 17:16:20.082726+00	vsbzr2uhhdvz	13fdd596-fd78-4814-b0c7-7ce3260bab71
00000000-0000-0000-0000-000000000000	580	ldf27iqyomib	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-03-03 17:16:20.096002+00	2026-03-03 17:16:20.096002+00	vttwr2ppkdan	13fdd596-fd78-4814-b0c7-7ce3260bab71
00000000-0000-0000-0000-000000000000	792	lrbrmgtponps	993dc109-8d6c-4369-8011-8b39b0059830	f	2026-03-09 09:01:18.271943+00	2026-03-09 09:01:18.271943+00	\N	b5aa6c9e-d6d2-40e1-bfd1-fbcbb1fdbf31
00000000-0000-0000-0000-000000000000	806	y3fpy6rqz6td	bcefc261-a2e7-4936-80c7-ff01bf33cb38	f	2026-03-09 10:34:51.004671+00	2026-03-09 10:34:51.004671+00	\N	148343c1-0667-48ef-8010-f0f00fa12bb3
00000000-0000-0000-0000-000000000000	582	r5rokwcfiikp	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-03-03 17:26:12.862273+00	2026-03-03 17:26:12.862273+00	ivy5xsyblrfb	2eacbbb8-8773-410f-ad1a-a708a5e3ef29
00000000-0000-0000-0000-000000000000	583	c34c5oekr4wo	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-03 17:29:51.149712+00	2026-03-03 18:28:07.950094+00	\N	59c188e5-0e1a-484f-a244-975f70554825
00000000-0000-0000-0000-000000000000	584	qw7iqsgkdkk6	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-03 17:33:19.277716+00	2026-03-03 18:49:40.120817+00	\N	7c58a9d3-f417-49da-a6eb-eed438347c9e
00000000-0000-0000-0000-000000000000	575	5l2lu5ozzomp	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-03 14:51:07.535155+00	2026-03-03 19:11:21.633708+00	tzelbpmrskoh	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	587	4r2xkmznwfn2	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-03 18:28:07.962714+00	2026-03-03 19:38:13.395361+00	c34c5oekr4wo	59c188e5-0e1a-484f-a244-975f70554825
00000000-0000-0000-0000-000000000000	589	rvjuflvu7xyj	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-03 19:11:21.652724+00	2026-03-03 20:27:19.839092+00	5l2lu5ozzomp	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	590	2my6iqq2owzk	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-03 19:38:13.414978+00	2026-03-04 07:13:49.858108+00	4r2xkmznwfn2	59c188e5-0e1a-484f-a244-975f70554825
00000000-0000-0000-0000-000000000000	588	ut3mepulld3u	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-03 18:49:40.131213+00	2026-03-04 08:10:11.999399+00	qw7iqsgkdkk6	7c58a9d3-f417-49da-a6eb-eed438347c9e
00000000-0000-0000-0000-000000000000	598	ka2e2jycyu4s	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	t	2026-03-04 07:54:10.178189+00	2026-03-04 08:58:15.642305+00	3bzchdw4vci6	1c4def97-0027-4852-83cd-6a71ffc224af
00000000-0000-0000-0000-000000000000	602	cdrf25irgmfq	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	t	2026-03-04 08:58:15.642736+00	2026-03-04 09:59:04.220522+00	ka2e2jycyu4s	1c4def97-0027-4852-83cd-6a71ffc224af
00000000-0000-0000-0000-000000000000	606	ky4endz6o2bv	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	t	2026-03-04 09:59:04.222846+00	2026-03-04 11:13:32.955454+00	cdrf25irgmfq	1c4def97-0027-4852-83cd-6a71ffc224af
00000000-0000-0000-0000-000000000000	595	m4ggoqspstqa	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-04 07:13:49.85918+00	2026-03-04 12:07:09.649435+00	2my6iqq2owzk	59c188e5-0e1a-484f-a244-975f70554825
00000000-0000-0000-0000-000000000000	613	7lmcg6pdegtv	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-03-04 12:07:09.656204+00	2026-03-04 12:07:09.656204+00	m4ggoqspstqa	59c188e5-0e1a-484f-a244-975f70554825
00000000-0000-0000-0000-000000000000	599	zormu4e47y3v	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-04 08:10:12.01187+00	2026-03-04 13:01:53.332124+00	ut3mepulld3u	7c58a9d3-f417-49da-a6eb-eed438347c9e
00000000-0000-0000-0000-000000000000	591	7zbqvt4itxjp	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-03 20:27:19.856359+00	2026-03-04 13:23:04.660822+00	rvjuflvu7xyj	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	617	qmclxv4tdorc	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-04 13:01:53.339521+00	2026-03-04 14:08:17.925022+00	zormu4e47y3v	7c58a9d3-f417-49da-a6eb-eed438347c9e
00000000-0000-0000-0000-000000000000	618	qln43y4xow62	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-04 13:23:04.690339+00	2026-03-04 14:45:03.739883+00	7zbqvt4itxjp	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	621	utzmgoraeoan	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-04 14:08:17.93389+00	2026-03-04 15:06:34.011558+00	qmclxv4tdorc	7c58a9d3-f417-49da-a6eb-eed438347c9e
00000000-0000-0000-0000-000000000000	610	76u4hbgkhnci	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	t	2026-03-04 11:13:32.955972+00	2026-03-04 15:28:46.248101+00	ky4endz6o2bv	1c4def97-0027-4852-83cd-6a71ffc224af
00000000-0000-0000-0000-000000000000	623	occe2t23dpup	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-04 14:45:03.755941+00	2026-03-04 15:43:25.354414+00	qln43y4xow62	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	655	f6njptz6w4ja	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-05 10:00:41.931741+00	2026-03-05 10:58:42.653131+00	jursjl3qcm4i	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	626	7rv4vgnd2oti	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-03-04 15:06:34.01865+00	2026-03-04 15:06:34.01865+00	utzmgoraeoan	7c58a9d3-f417-49da-a6eb-eed438347c9e
00000000-0000-0000-0000-000000000000	678	y5nh6y2s6fny	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-05 14:53:36.323557+00	2026-03-06 18:24:31.012224+00	kmtar4kc5gcz	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	849	izq5hspq2x3m	fdaf6d5b-b6de-4dcb-bcb5-fbf0276736bf	t	2026-03-11 07:41:11.768533+00	2026-03-11 09:26:32.203495+00	2lkour7n5jmx	a5a32e36-9c2e-4a5c-b5e5-3d5ba9b5b983
00000000-0000-0000-0000-000000000000	627	7yfoeeqdtkxz	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-04 15:10:53.794877+00	2026-03-05 07:33:57.279031+00	\N	0542fb23-f10e-4594-8de0-498ed95a8341
00000000-0000-0000-0000-000000000000	629	lcdssq2bxzer	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	t	2026-03-04 15:28:46.266141+00	2026-03-05 09:34:53.823095+00	76u4hbgkhnci	1c4def97-0027-4852-83cd-6a71ffc224af
00000000-0000-0000-0000-000000000000	631	jursjl3qcm4i	c4ec5e93-766d-48c2-8312-8c673287fbd9	t	2026-03-04 15:43:25.373564+00	2026-03-05 10:00:41.92859+00	occe2t23dpup	12be3362-7cd5-4400-97ce-b93b746dda56
00000000-0000-0000-0000-000000000000	656	7wiustqdwrvo	849e4383-8caf-420f-a13d-4e3393ee4645	f	2026-03-05 10:10:38.110567+00	2026-03-05 10:10:38.110567+00	\N	d3504db3-2aa9-47b9-8b3a-4c7a06c40aeb
00000000-0000-0000-0000-000000000000	646	i3rx5wcxuesr	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	t	2026-03-05 07:33:57.29066+00	2026-03-05 10:18:24.662819+00	7yfoeeqdtkxz	0542fb23-f10e-4594-8de0-498ed95a8341
00000000-0000-0000-0000-000000000000	658	qp5mvwhawpon	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	f	2026-03-05 10:18:24.66532+00	2026-03-05 10:18:24.66532+00	i3rx5wcxuesr	0542fb23-f10e-4594-8de0-498ed95a8341
00000000-0000-0000-0000-000000000000	651	cc7zwfodtnoa	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	t	2026-03-05 09:34:53.833372+00	2026-03-05 10:40:07.655673+00	lcdssq2bxzer	1c4def97-0027-4852-83cd-6a71ffc224af
00000000-0000-0000-0000-000000000000	664	tw6ljqcvt4hx	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	f	2026-03-05 10:40:07.658589+00	2026-03-05 10:40:07.658589+00	cc7zwfodtnoa	1c4def97-0027-4852-83cd-6a71ffc224af
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
b5aa6c9e-d6d2-40e1-bfd1-fbcbb1fdbf31	993dc109-8d6c-4369-8011-8b39b0059830	2026-03-09 09:01:18.247254+00	2026-03-09 09:01:18.247254+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.201.20	\N	\N	\N	\N	\N
2775d9f0-f93e-4f89-be9d-187ba88836f9	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-17 13:39:46.203391+00	2026-02-17 13:39:46.203391+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	213.211.234.212	\N	\N	\N	\N	\N
ba84d120-f4fd-437e-b391-2de5c6286f0c	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-16 14:44:58.3569+00	2026-02-16 17:11:42.528036+00	\N	aal1	\N	2026-02-16 17:11:42.527916	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.222.246	\N	\N	\N	\N	\N
fe5c6b89-8d21-4592-92b7-b12dbbd98e19	e7450c22-ab44-440a-bfb7-bc14a9defb05	2026-02-16 18:05:19.262811+00	2026-02-16 18:05:19.262811+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.222.246	\N	\N	\N	\N	\N
d9cdd500-4426-4a65-ae40-7ecab1610bca	31536e18-7556-4d82-b41c-2ece065db4dc	2026-02-16 18:06:02.242426+00	2026-02-16 18:06:02.242426+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.222.246	\N	\N	\N	\N	\N
0b9dae88-1c2b-46fd-afae-d74735be41dd	5d3560c5-3d76-4606-80e8-7eb69ce36a51	2026-02-16 19:02:59.350298+00	2026-02-16 19:02:59.350298+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.222.246	\N	\N	\N	\N	\N
95738a33-c019-4ac7-9877-0b7b4d73bf00	db2eea71-c184-41bb-84bf-e6bb40c770fd	2026-02-16 19:04:05.938325+00	2026-02-16 19:04:05.938325+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.222.246	\N	\N	\N	\N	\N
41662b58-18d5-406e-b68c-f39a28e1a022	d071f9b2-ce73-44a2-b015-2a2d8efe1503	2026-02-17 14:00:03.599826+00	2026-02-17 14:00:03.599826+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	109.75.93.96	\N	\N	\N	\N	\N
890751a4-5d95-4c37-a28d-40c8af6cf6e3	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	2026-02-17 14:00:33.554188+00	2026-02-17 14:00:33.554188+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
2e8c68ff-d5d2-45f1-b5bc-a658f4a09711	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-17 14:00:37.574668+00	2026-02-17 14:00:37.574668+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	213.211.234.212	\N	\N	\N	\N	\N
59b912ee-7ee4-4086-bbca-ec38bd7e35d0	d071f9b2-ce73-44a2-b015-2a2d8efe1503	2026-02-17 14:01:25.428246+00	2026-02-17 14:01:25.428246+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
0a93fd1e-3b17-4ca7-be1a-5a4aeb0338c0	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	2026-02-17 14:02:31.225553+00	2026-02-17 14:02:31.225553+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0	176.1.223.238	\N	\N	\N	\N	\N
200fe79a-3d32-494b-a650-5fb95fe1bc50	9852c5b1-e17b-402e-81fa-6b638f610264	2026-02-17 08:30:14.395467+00	2026-02-17 10:30:08.884807+00	\N	aal1	\N	2026-02-17 10:30:08.884682	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
b64f9be4-2fa0-4d5b-b7c7-db97945c1b1c	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-17 11:47:52.886584+00	2026-02-17 12:56:01.883698+00	\N	aal1	\N	2026-02-17 12:56:01.883578	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
fb798671-07e5-408f-9628-f8899062efb3	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-17 12:59:22.852124+00	2026-02-17 12:59:22.852124+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
db50e822-dc01-4f52-95ff-beb029e29386	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-17 13:00:23.909935+00	2026-02-17 13:00:23.909935+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
84a8567a-0cf7-4e75-8c83-f02a25b091ad	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-17 13:02:12.886016+00	2026-02-17 13:02:12.886016+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	213.211.234.212	\N	\N	\N	\N	\N
79a47e5c-dcaa-443d-9743-7590959daf1f	d071f9b2-ce73-44a2-b015-2a2d8efe1503	2026-02-17 13:03:59.931172+00	2026-02-17 13:03:59.931172+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	109.75.93.96	\N	\N	\N	\N	\N
fdb73807-cbb2-45db-a8c0-e28be3c8fca8	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-17 13:05:03.986294+00	2026-02-17 13:05:03.986294+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	213.211.234.212	\N	\N	\N	\N	\N
7ce1fdaf-4a81-4e72-a29e-5b279ba0d0d1	d071f9b2-ce73-44a2-b015-2a2d8efe1503	2026-02-17 13:05:08.768407+00	2026-02-17 13:05:08.768407+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	109.75.93.96	\N	\N	\N	\N	\N
5f5fcd62-060d-498b-a0c4-cf959578ed0e	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-17 13:06:50.119673+00	2026-02-17 13:06:50.119673+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
e12199cd-6b8e-43f6-bf83-a23c0b1163e0	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-17 13:14:07.709957+00	2026-02-17 13:14:07.709957+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	213.211.234.212	\N	\N	\N	\N	\N
bac69b22-b81d-4391-beae-2641151c7e64	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	2026-02-17 14:02:49.683756+00	2026-02-17 14:02:49.683756+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0	176.1.223.238	\N	\N	\N	\N	\N
9be04c45-692e-4eec-8bd5-1d2a905006d7	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-17 14:03:15.590529+00	2026-02-17 14:03:15.590529+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
ebb842f9-ce26-4226-8e02-94262484b4e0	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	2026-02-17 14:04:00.734168+00	2026-02-17 14:04:00.734168+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0	176.1.223.238	\N	\N	\N	\N	\N
30e1867a-a5f3-403d-a322-02e78015d89f	d071f9b2-ce73-44a2-b015-2a2d8efe1503	2026-02-17 14:04:20.190566+00	2026-02-17 14:04:20.190566+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	109.75.93.96	\N	\N	\N	\N	\N
7e6adb9a-b376-4b10-b061-e22a3b32feb4	d071f9b2-ce73-44a2-b015-2a2d8efe1503	2026-02-17 14:05:27.332699+00	2026-02-17 14:05:27.332699+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
2c1bb0b7-5b1d-4bbf-a879-4380a070e555	d071f9b2-ce73-44a2-b015-2a2d8efe1503	2026-02-17 14:05:37.602198+00	2026-02-17 14:05:37.602198+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	109.75.93.96	\N	\N	\N	\N	\N
7f1758a0-617c-494b-beb3-c99e2c86817c	d071f9b2-ce73-44a2-b015-2a2d8efe1503	2026-02-17 14:06:49.836247+00	2026-02-17 14:06:49.836247+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
35c7f1de-31b9-4a4e-a76c-c891d633180f	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-17 14:10:06.571226+00	2026-02-17 14:10:06.571226+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
3256efed-2514-49a3-9e8b-55b55c4b3826	560902da-285b-493c-8d46-16be17996519	2026-02-17 14:12:16.808098+00	2026-02-17 14:12:16.808098+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
94ea9f8d-e09e-4ddb-ba75-bb37ba8416a4	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	2026-02-17 14:14:13.6647+00	2026-02-17 14:14:13.6647+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0	176.1.223.238	\N	\N	\N	\N	\N
499b0b19-fc82-437e-8bd0-47b9ed36df9a	d071f9b2-ce73-44a2-b015-2a2d8efe1503	2026-02-17 14:19:15.808518+00	2026-02-17 14:19:15.808518+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
81ac6413-11a1-4430-a035-c4bb4a3451cd	d071f9b2-ce73-44a2-b015-2a2d8efe1503	2026-02-17 14:22:15.481721+00	2026-02-17 14:22:15.481721+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
29944caf-1aa9-416c-be71-5a33f6a8490e	86c1d4b2-d9b8-4972-880c-9a8d3220d1d1	2026-02-17 14:23:29.844586+00	2026-02-17 14:23:29.844586+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0	176.1.223.238	\N	\N	\N	\N	\N
83390bb2-9482-419b-aff5-1b747f57e9fa	312fbd38-46b4-4611-bf01-ea5b58854967	2026-02-17 14:25:19.790696+00	2026-02-17 14:25:19.790696+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
d06e7ef5-0cf3-4314-8702-1fb775b7e857	86c1d4b2-d9b8-4972-880c-9a8d3220d1d1	2026-02-17 14:23:44.595235+00	2026-02-17 15:34:36.645179+00	\N	aal1	\N	2026-02-17 15:34:36.645074	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0	176.1.223.238	\N	\N	\N	\N	\N
bb6c0eae-ae89-426c-9419-4cf74def72f1	d071f9b2-ce73-44a2-b015-2a2d8efe1503	2026-02-17 14:31:53.916274+00	2026-02-17 14:31:53.916274+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
12e61b4b-d4a7-44e7-98e1-5699626a9eed	d071f9b2-ce73-44a2-b015-2a2d8efe1503	2026-02-17 14:38:57.102216+00	2026-02-17 14:38:57.102216+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
763254bb-c2aa-49a7-800a-53e670a85ac3	560902da-285b-493c-8d46-16be17996519	2026-02-17 14:39:21.279276+00	2026-02-17 14:39:21.279276+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
18e99fae-79cc-4948-bb55-fc4e875776e3	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	2026-02-17 14:39:40.472582+00	2026-02-17 14:39:40.472582+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
3af17e5e-a1e9-458f-b009-aa57f1a995ff	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	2026-02-17 14:41:22.877146+00	2026-02-17 14:41:22.877146+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
55461262-cf41-4cdf-b2b0-02946a87b74c	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	2026-02-17 15:34:47.944575+00	2026-02-17 15:34:47.944575+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0	176.1.223.238	\N	\N	\N	\N	\N
7808b525-3751-4459-9abe-ab37f167a967	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-17 16:57:08.054392+00	2026-02-18 08:07:00.851754+00	\N	aal1	\N	2026-02-18 08:07:00.851654	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.205.171	\N	\N	\N	\N	\N
b73698ca-262b-49e3-89f5-abca6e255bf8	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	2026-02-17 15:45:12.232018+00	2026-02-17 15:45:12.232018+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0	176.1.223.238	\N	\N	\N	\N	\N
3f480e29-9bc1-4a0a-ae48-80f93b5955ae	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	2026-02-17 15:45:29.771276+00	2026-02-17 15:45:29.771276+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0	176.1.223.238	\N	\N	\N	\N	\N
e485928a-a49f-438b-9f1d-354e8eba91aa	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-18 08:10:08.41892+00	2026-02-18 08:10:08.41892+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.205.171	\N	\N	\N	\N	\N
12a538c9-838d-40eb-9f82-ce3ddbaeead4	560902da-285b-493c-8d46-16be17996519	2026-02-17 14:41:44.090189+00	2026-02-17 16:36:28.766342+00	\N	aal1	\N	2026-02-17 16:36:28.764468	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
78cd1562-7867-441e-9df4-f74e6a651f51	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-17 16:37:24.625936+00	2026-02-17 16:37:24.625936+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
6d69da0f-d7b5-42bb-862c-d3849016fec8	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-17 16:37:54.776794+00	2026-02-17 16:37:54.776794+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
0a17f5ce-dd3c-4008-b0ae-5fee1875f52a	d071f9b2-ce73-44a2-b015-2a2d8efe1503	2026-02-17 16:38:19.662009+00	2026-02-17 16:38:19.662009+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
1854594f-d9b9-41c4-b1e4-65fec4b7ce15	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-17 16:38:31.471235+00	2026-02-17 16:38:31.471235+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
00ec2db2-5612-4fe5-b679-42f485fb1a80	d071f9b2-ce73-44a2-b015-2a2d8efe1503	2026-02-17 14:31:24.440687+00	2026-02-17 16:41:23.32449+00	\N	aal1	\N	2026-02-17 16:41:23.324347	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	213.211.234.212	\N	\N	\N	\N	\N
3d32c47a-d4bf-432c-9119-cb99560ef38d	a1d1c5fa-e722-4251-907c-afd134b085df	2026-02-17 16:46:30.316932+00	2026-02-17 16:46:30.316932+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
df825fb5-6320-433e-bdbc-81447e80c041	a1d1c5fa-e722-4251-907c-afd134b085df	2026-02-17 16:46:42.408735+00	2026-02-17 16:46:42.408735+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
54cff7fd-f7f3-44d0-ad91-8bfd4cd79708	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-17 16:47:13.151358+00	2026-02-17 16:47:13.151358+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.171.53	\N	\N	\N	\N	\N
d7bbf19c-ca78-4a08-a8a5-36ee95156d3a	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	2026-02-17 15:54:53.473192+00	2026-02-17 17:23:37.510925+00	\N	aal1	\N	2026-02-17 17:23:37.510794	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0	176.1.223.238	\N	\N	\N	\N	\N
4ab51fe5-a56d-43b7-a376-e3fdb9b1f91a	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-18 08:12:20.567581+00	2026-02-18 08:12:20.567581+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36	31.150.205.171	\N	\N	\N	\N	\N
f275c52e-f385-43ed-86e2-e988d5b7795d	306b5d39-a4ee-4848-a64a-01ad4ffa241d	2026-02-18 11:23:23.501632+00	2026-02-18 11:23:23.501632+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.205.171	\N	\N	\N	\N	\N
ab835af8-c718-49a0-82ff-d54fd2d3727a	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-18 08:14:02.256855+00	2026-02-18 08:14:02.256855+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36	31.150.205.171	\N	\N	\N	\N	\N
05c44ef7-1679-4e3b-8184-0e848e32dcf8	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-17 16:57:09.584945+00	2026-02-18 11:50:46.400562+00	\N	aal1	\N	2026-02-18 11:50:46.398739	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	213.211.234.212	\N	\N	\N	\N	\N
5a0582f2-27ef-497d-9f8f-d2c202dcf389	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-18 08:17:13.871981+00	2026-02-18 10:32:04.114158+00	\N	aal1	\N	2026-02-18 10:32:04.113451	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36	31.150.205.171	\N	\N	\N	\N	\N
25c2e177-3b97-4c31-9c0b-ef7bfa223b39	d071f9b2-ce73-44a2-b015-2a2d8efe1503	2026-02-17 14:08:22.934332+00	2026-02-18 15:58:24.259603+00	\N	aal1	\N	2026-02-18 15:58:24.259486	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	109.75.93.96	\N	\N	\N	\N	\N
6a4d01e9-cad7-4723-8845-b6466a2174a8	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	2026-02-18 11:23:40.995808+00	2026-02-18 11:23:40.995808+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.205.171	\N	\N	\N	\N	\N
4d63bee2-24ad-48d7-af90-1b02ac4370cf	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	2026-02-17 17:28:01.489657+00	2026-02-18 09:20:15.94632+00	\N	aal1	\N	2026-02-18 09:20:15.946216	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36 Edg/145.0.0.0	176.1.221.83	\N	\N	\N	\N	\N
7ffb102c-41c9-4a1b-94a7-92df379af1df	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	2026-02-18 09:27:24.30577+00	2026-02-18 09:27:24.30577+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36 Edg/145.0.0.0	176.1.221.83	\N	\N	\N	\N	\N
d8582c75-1e8d-44ac-8c63-4fdf856c646b	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-18 11:09:18.079383+00	2026-02-18 11:09:18.079383+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.205.171	\N	\N	\N	\N	\N
0846d543-467e-4f12-8347-9260486bf249	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-18 11:26:26.016467+00	2026-02-20 09:58:25.740812+00	\N	aal1	\N	2026-02-20 09:58:25.740142	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.180.245	\N	\N	\N	\N	\N
2521feb6-ff7f-48c6-ad67-a59bbdd80ebe	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-18 12:37:46.288072+00	2026-02-18 18:10:09.386879+00	\N	aal1	\N	2026-02-18 18:10:09.385565	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	213.211.234.212	\N	\N	\N	\N	\N
8324ab27-5e71-4e11-8cc6-243612f2892b	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-18 18:28:58.99679+00	2026-02-19 10:12:10.702429+00	\N	aal1	\N	2026-02-19 10:12:10.702311	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	213.211.234.212	\N	\N	\N	\N	\N
708bb470-1253-4403-a9a2-bed497029491	73ebb754-d8b0-46d2-bea9-846fa82d3657	2026-03-09 10:25:40.96099+00	2026-03-09 10:25:40.96099+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.201.20	\N	\N	\N	\N	\N
148343c1-0667-48ef-8010-f0f00fa12bb3	bcefc261-a2e7-4936-80c7-ff01bf33cb38	2026-03-09 10:34:50.994493+00	2026-03-09 10:34:50.994493+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 18_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.5 Mobile/15E148 Safari/604.1	31.150.201.20	\N	\N	\N	\N	\N
5b71cd4c-c447-4f04-92be-5afcc9db5d36	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-19 10:12:12.622917+00	2026-02-19 11:22:16.051017+00	\N	aal1	\N	2026-02-19 11:22:16.049723	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	213.211.234.212	\N	\N	\N	\N	\N
ac0c7844-3e23-45c4-8226-1bfb88c36ddc	b0187f61-fe65-436d-a9f8-dc1a2b4d307e	2026-03-09 10:27:30.56544+00	2026-03-09 10:27:30.56544+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.201.20	\N	\N	\N	\N	\N
bbaf75e5-e893-40b9-af88-1feb9d976d12	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-19 12:12:41.823561+00	2026-02-19 14:08:44.807948+00	\N	aal1	\N	2026-02-19 14:08:44.807844	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	213.211.234.212	\N	\N	\N	\N	\N
05824fe1-98de-4ba1-9b75-4e08d7cac146	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-20 12:33:50.887215+00	2026-02-20 13:32:14.429625+00	\N	aal1	\N	2026-02-20 13:32:14.428948	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Mobile Safari/537.36	213.211.211.229	\N	\N	\N	\N	\N
2eacbbb8-8773-410f-ad1a-a708a5e3ef29	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-22 09:50:04.982562+00	2026-03-03 17:26:12.879059+00	\N	aal1	\N	2026-03-03 17:26:12.878953	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.167.240	\N	\N	\N	\N	\N
e112cbc6-dbdb-46ab-aee6-92d6a5cffc18	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-24 07:24:01.849909+00	2026-02-25 07:24:20.995191+00	\N	aal1	\N	2026-02-25 07:24:20.995074	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.173.237	\N	\N	\N	\N	\N
922e9c32-e9ac-4b59-9b1c-faee37586f69	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-20 13:53:12.247007+00	2026-02-20 15:12:36.187926+00	\N	aal1	\N	2026-02-20 15:12:36.186053	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	213.211.211.229	\N	\N	\N	\N	\N
f0a9cb41-bd22-41f3-ad47-75d396686025	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-20 15:13:36.012743+00	2026-02-20 15:13:36.012743+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	213.211.211.229	\N	\N	\N	\N	\N
5501bda7-4d4b-4afc-a8b7-0921399db3e9	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-20 10:18:28.945227+00	2026-02-23 17:55:31.704172+00	\N	aal1	\N	2026-02-23 17:55:31.704058	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.157.20	\N	\N	\N	\N	\N
e4f2bcd3-0450-400d-b1de-9b29d0728b66	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-20 15:25:41.548365+00	2026-02-20 15:25:41.548365+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	213.211.211.229	\N	\N	\N	\N	\N
344c9d75-8c3b-4f31-80d8-abee28b3826b	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-20 15:35:39.695653+00	2026-02-20 15:35:39.695653+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.180.245	\N	\N	\N	\N	\N
5b8f3689-ea63-4b78-87a7-1954b9511d2c	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-20 15:36:56.665626+00	2026-02-20 15:36:56.665626+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.180.245	\N	\N	\N	\N	\N
cc1ccc9a-c570-46a9-b3b8-2404ae2a26f0	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-20 15:37:08.545118+00	2026-02-20 15:37:08.545118+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	213.211.211.229	\N	\N	\N	\N	\N
1c4def97-0027-4852-83cd-6a71ffc224af	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	2026-02-20 15:37:21.560881+00	2026-03-05 10:40:07.661581+00	\N	aal1	\N	2026-03-05 10:40:07.660877	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36 Edg/145.0.0.0	176.1.209.89	\N	\N	\N	\N	\N
29b13c37-a5d5-4295-b568-73f5b08024dc	306b5d39-a4ee-4848-a64a-01ad4ffa241d	2026-02-20 10:55:34.690109+00	2026-02-20 10:55:34.690109+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	213.211.211.229	\N	\N	\N	\N	\N
01413de3-2563-4c2e-ab2f-7fca2e016dac	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-19 14:26:00.255575+00	2026-02-20 11:43:20.057686+00	\N	aal1	\N	2026-02-20 11:43:20.056301	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	213.211.211.229	\N	\N	\N	\N	\N
ed2bc9ce-96ce-4c37-a9d0-765f91b64780	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-20 15:38:05.140728+00	2026-02-23 18:03:37.717728+00	\N	aal1	\N	2026-02-23 18:03:37.717036	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	213.211.211.103	\N	\N	\N	\N	\N
95570d1b-b072-4ab4-be37-857176670cf9	306b5d39-a4ee-4848-a64a-01ad4ffa241d	2026-02-20 10:56:08.493341+00	2026-02-20 12:23:43.347908+00	\N	aal1	\N	2026-02-20 12:23:43.347148	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	213.211.211.229	\N	\N	\N	\N	\N
72f67b78-5c73-4add-947a-ae4ccc504d5a	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-20 12:55:33.412955+00	2026-02-20 12:55:33.412955+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	31.150.180.245	\N	\N	\N	\N	\N
5c7870be-5b05-4ada-b5a3-b94bfbb75442	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-20 12:38:30.560484+00	2026-02-20 15:38:53.422975+00	\N	aal1	\N	2026-02-20 15:38:53.422877	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36	213.211.211.229	\N	\N	\N	\N	\N
b01b150f-a2a0-49db-a81c-682cd6f320fa	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-24 18:37:18.606418+00	2026-02-24 18:37:18.606418+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	213.211.211.119	\N	\N	\N	\N	\N
8d55a955-6f7f-494f-88e6-7d278675097d	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-23 18:15:27.309944+00	2026-02-23 18:15:27.309944+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.157.20	\N	\N	\N	\N	\N
d470f314-dba7-4cdb-8c32-59e4c59d63d8	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-24 18:37:32.599213+00	2026-02-24 18:37:32.599213+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	213.211.211.119	\N	\N	\N	\N	\N
7957ff95-3335-4487-b9e5-a5553f33b644	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-20 13:01:36.013385+00	2026-02-22 09:49:34.160245+00	\N	aal1	\N	2026-02-22 09:49:34.159549	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.157.208	\N	\N	\N	\N	\N
aafc6906-34ce-4925-9049-8f82b504da47	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-24 18:41:09.38867+00	2026-02-24 18:41:09.38867+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	213.211.211.119	\N	\N	\N	\N	\N
57e7fc31-cf70-4613-a2fe-8a7b4e57607f	306b5d39-a4ee-4848-a64a-01ad4ffa241d	2026-02-23 18:22:11.884171+00	2026-02-24 06:57:42.715671+00	\N	aal1	\N	2026-02-24 06:57:42.712662	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.213.57	\N	\N	\N	\N	\N
e2523bd1-ce69-4dcf-a45d-c4678ddfff29	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-23 18:04:42.638068+00	2026-02-24 17:12:17.627636+00	\N	aal1	\N	2026-02-24 17:12:17.626959	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	213.211.211.119	\N	\N	\N	\N	\N
6761dae3-442b-4a0c-8e78-2613a27fd90e	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-24 17:12:18.620909+00	2026-02-24 17:12:18.620909+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	213.211.211.119	\N	\N	\N	\N	\N
67855094-e439-490c-82a2-3b1a60dfa484	a1d1c5fa-e722-4251-907c-afd134b085df	2026-02-24 18:57:49.192521+00	2026-02-25 07:59:26.763056+00	\N	aal1	\N	2026-02-25 07:59:26.762251	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	213.211.211.227	\N	\N	\N	\N	\N
2edb42f5-9060-4358-8ad0-e9dd8e5e6a8e	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-24 17:18:15.91663+00	2026-02-24 18:19:27.030478+00	\N	aal1	\N	2026-02-24 18:19:27.028605	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	213.211.211.119	\N	\N	\N	\N	\N
110072b5-f096-4131-b3bf-ce4cb10a007f	a1d1c5fa-e722-4251-907c-afd134b085df	2026-02-25 08:13:12.90199+00	2026-02-25 08:13:12.90199+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	213.211.211.227	\N	\N	\N	\N	\N
2045ba4a-9cdb-47ac-b162-4f89b71ccacd	a1d1c5fa-e722-4251-907c-afd134b085df	2026-02-24 18:31:32.831739+00	2026-02-24 18:31:32.831739+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	213.211.211.119	\N	\N	\N	\N	\N
1fc95765-74be-4a05-87dc-9d9ef84138b3	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-25 08:09:27.445046+00	2026-02-25 08:09:27.445046+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	213.211.211.227	\N	\N	\N	\N	\N
6f000ef3-6fdc-4366-a41a-761ad44db9d6	d071f9b2-ce73-44a2-b015-2a2d8efe1503	2026-02-25 08:13:43.064262+00	2026-02-25 08:13:43.064262+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	213.211.211.227	\N	\N	\N	\N	\N
70decc67-f748-4257-8c23-f294ec203927	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	2026-02-25 08:15:48.684658+00	2026-02-25 08:15:48.684658+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.173.237	\N	\N	\N	\N	\N
64984977-ccd2-48d4-95db-51e916e1c775	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-25 08:17:08.083099+00	2026-02-25 08:17:08.083099+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.173.237	\N	\N	\N	\N	\N
7c048b83-087a-4efd-a751-ac714bc7979e	a1d1c5fa-e722-4251-907c-afd134b085df	2026-02-25 08:18:54.670581+00	2026-02-25 08:18:54.670581+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	213.211.211.227	\N	\N	\N	\N	\N
71744bbf-6091-4e4c-b1f3-7e0261159857	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-25 08:17:23.449781+00	2026-02-25 21:56:27.309881+00	\N	aal1	\N	2026-02-25 21:56:27.308521	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	128.90.151.19	\N	\N	\N	\N	\N
c49cc55d-fcb6-43dd-b601-492199c658ee	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-25 21:59:35.180057+00	2026-02-25 21:59:35.180057+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	128.90.151.19	\N	\N	\N	\N	\N
b4fdae1e-0386-4c68-a285-d5747b202472	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	2026-02-25 22:00:26.20888+00	2026-02-25 22:00:26.20888+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	128.90.151.19	\N	\N	\N	\N	\N
976500e2-0416-4d6a-9c2f-e0930e762dcb	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-25 22:00:50.966887+00	2026-02-27 07:28:57.566262+00	\N	aal1	\N	2026-02-27 07:28:57.566147	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	37.138.45.235	\N	\N	\N	\N	\N
59c188e5-0e1a-484f-a244-975f70554825	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-03-03 17:29:51.136482+00	2026-03-04 12:07:09.666839+00	\N	aal1	\N	2026-03-04 12:07:09.66639	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.202.94	\N	\N	\N	\N	\N
a8f2d17a-9f44-4da5-842e-bb69317e987c	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-27 07:39:24.136969+00	2026-02-27 20:27:55.016157+00	\N	aal1	\N	2026-02-27 20:27:55.016054	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	37.138.45.235	\N	\N	\N	\N	\N
13fdd596-fd78-4814-b0c7-7ce3260bab71	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-03-03 10:58:17.359275+00	2026-03-03 17:16:20.124435+00	\N	aal1	\N	2026-03-03 17:16:20.123038	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.167.240	\N	\N	\N	\N	\N
2046e76d-2c8a-42ff-8b3d-457716c373b1	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-25 21:10:19.078295+00	2026-02-27 12:16:05.275738+00	\N	aal1	\N	2026-02-27 12:16:05.274464	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	213.211.234.127	\N	\N	\N	\N	\N
0542fb23-f10e-4594-8de0-498ed95a8341	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-03-04 15:10:53.783972+00	2026-03-05 10:18:24.670041+00	\N	aal1	\N	2026-03-05 10:18:24.669344	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.159.213	\N	\N	\N	\N	\N
541ac0bc-3df8-4dc7-9769-c1246ecdd45c	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-27 12:16:10.60889+00	2026-02-27 13:36:44.067941+00	\N	aal1	\N	2026-02-27 13:36:44.067826	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	213.211.234.127	\N	\N	\N	\N	\N
e2ebfcc8-56fe-435a-86cc-3966a8b2b9ea	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-03-01 07:57:28.62666+00	2026-03-03 10:33:36.489496+00	\N	aal1	\N	2026-03-03 10:33:36.488771	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.167.240	\N	\N	\N	\N	\N
ba9b8494-24b3-4931-ac1c-56f39c89173b	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-28 16:29:35.37853+00	2026-03-01 07:57:18.224128+00	\N	aal1	\N	2026-03-01 07:57:18.22402	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.163.211	\N	\N	\N	\N	\N
a438af8b-7705-44be-b12a-e3fc7aa96314	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-27 14:02:35.189778+00	2026-02-28 11:57:25.240964+00	\N	aal1	\N	2026-02-28 11:57:25.240126	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	213.211.211.223	\N	\N	\N	\N	\N
2fd777ec-6d8c-4f12-b553-6fad05fb2053	092175d3-fa6b-4b6d-9a62-67a547151b5c	2026-03-09 10:23:51.754775+00	2026-03-09 10:23:51.754775+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.201.20	\N	\N	\N	\N	\N
f032bc4d-e36e-4f8e-bb95-e107cd5f421a	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-25 08:23:46.358207+00	2026-02-25 20:58:29.077045+00	\N	aal1	\N	2026-02-25 20:58:29.076941	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	213.211.211.227	\N	\N	\N	\N	\N
3f281e0e-1cb9-4915-9604-9228e198e9f5	1c0f7c19-3851-4429-91c9-6b8d67d4e7b7	2026-03-09 10:32:02.822842+00	2026-03-09 10:32:02.822842+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.201.20	\N	\N	\N	\N	\N
fa6fcc8c-6d2e-41f5-8425-eda1e998bbf9	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-03-05 12:37:18.770691+00	2026-03-05 18:20:49.343641+00	\N	aal1	\N	2026-03-05 18:20:49.342919	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.159.213	\N	\N	\N	\N	\N
b0d3a4c7-121f-42b8-8ef6-09c519fd2068	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-02-27 21:11:10.998177+00	2026-02-28 16:29:29.950117+00	\N	aal1	\N	2026-02-28 16:29:29.948707	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.182.108	\N	\N	\N	\N	\N
7c58a9d3-f417-49da-a6eb-eed438347c9e	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-03-03 17:33:19.275144+00	2026-03-04 15:06:34.030156+00	\N	aal1	\N	2026-03-04 15:06:34.030036	Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Mobile Safari/537.36	31.150.202.94	\N	\N	\N	\N	\N
d3504db3-2aa9-47b9-8b3a-4c7a06c40aeb	849e4383-8caf-420f-a13d-4e3393ee4645	2026-03-05 10:10:38.091519+00	2026-03-05 10:10:38.091519+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	157.180.227.195	\N	\N	\N	\N	\N
04a1446b-a12f-44ab-90d5-08926c52861a	217a05cc-7709-4e39-a0cf-ede8b02d87a4	2026-03-09 13:48:09.290217+00	2026-03-09 13:48:09.290217+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	109.75.93.181	\N	\N	\N	\N	\N
8f6947bd-d612-40f0-85e7-f33c03b6025b	21f90788-2d49-4547-b867-d52455e0d56b	2026-03-05 19:09:07.507668+00	2026-03-05 19:09:07.507668+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.159.213	\N	\N	\N	\N	\N
f1d869fa-7f2b-48f3-b7ae-eb60042e4883	8642c8b5-f0b9-4811-8f7a-425155de9d1d	2026-03-05 19:12:42.338358+00	2026-03-05 19:12:42.338358+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.159.213	\N	\N	\N	\N	\N
885eb734-1be1-4749-b690-15d49b7bf830	da0ff70f-fb32-418b-b84f-f66d7fcf6685	2026-03-06 16:03:28.234637+00	2026-03-06 16:03:28.234637+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.212.120	\N	\N	\N	\N	\N
f9ce0ceb-73af-4d0f-812d-349b2f0d17fb	b6ccc057-3ea9-4e5f-89b0-d28e37acb208	2026-03-06 16:05:08.989698+00	2026-03-06 16:05:08.989698+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.212.120	\N	\N	\N	\N	\N
12be3362-7cd5-4400-97ce-b93b746dda56	c4ec5e93-766d-48c2-8312-8c673287fbd9	2026-02-28 11:57:26.333815+00	2026-03-06 18:24:31.073929+00	\N	aal1	\N	2026-03-06 18:24:31.072662	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	213.211.234.215	\N	\N	\N	\N	\N
c55d7896-8914-4b9a-9fb6-33a38e561179	14c5bf86-010f-4355-b352-200ddc0c4aee	2026-03-07 07:42:51.924057+00	2026-03-07 07:42:51.924057+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	109.75.93.181	\N	\N	\N	\N	\N
ebbbf287-a0ea-4e5c-9a3d-1cf2db0e5865	924c7e03-fc42-479c-b841-c7eaa607cdc6	2026-03-09 08:09:54.09217+00	2026-03-09 08:09:54.09217+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	61.8.142.246	\N	\N	\N	\N	\N
a1964111-fed5-4c31-9a70-6bcc7bc06494	d071f9b2-ce73-44a2-b015-2a2d8efe1503	2026-03-10 14:12:46.819334+00	2026-03-10 14:12:46.819334+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	109.75.93.181	\N	\N	\N	\N	\N
2673a89a-f8aa-4f8c-bd64-b2de217640d9	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	2026-03-10 14:55:13.214666+00	2026-03-10 17:43:00.359409+00	\N	aal1	\N	2026-03-10 17:43:00.358028	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	31.150.160.243	\N	\N	\N	\N	\N
a5a32e36-9c2e-4a5c-b5e5-3d5ba9b5b983	fdaf6d5b-b6de-4dcb-bcb5-fbf0276736bf	2026-03-10 15:21:08.34924+00	2026-03-11 09:26:32.24704+00	\N	aal1	\N	2026-03-11 09:26:32.24653	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36	157.180.227.125	\N	\N	\N	\N	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	a1d1c5fa-e722-4251-907c-afd134b085df	authenticated	authenticated	b.blarr@dmx.de	$2a$10$kCfs.yyvx4sqKp5zS5N53uBzB9dfEvrXjW2z/pP5uH3cuIepFBHcO	2026-02-17 16:46:30.309272+00	\N		\N		\N			\N	2026-02-25 08:18:54.670492+00	{"provider": "email", "providers": ["email"]}	{"sub": "a1d1c5fa-e722-4251-907c-afd134b085df", "email": "b.blarr@dmx.de", "display_name": "Benjamin Blaar", "email_verified": true, "phone_verified": false}	\N	2026-02-17 16:46:30.289666+00	2026-02-25 08:18:54.67402+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	86c1d4b2-d9b8-4972-880c-9a8d3220d1d1	authenticated	authenticated	test@gmail.com	$2a$10$oX/7VY2WutVR/cjDbHX6qOX0Fz8zlbcker5Vy7hLnLwCa7oRpJsVC	2026-02-17 14:23:29.838038+00	\N		\N		\N			\N	2026-02-17 14:23:44.595136+00	{"provider": "email", "providers": ["email"]}	{"sub": "86c1d4b2-d9b8-4972-880c-9a8d3220d1d1", "email": "test@gmail.com", "display_name": "ser", "email_verified": true, "phone_verified": false}	\N	2026-02-17 14:23:29.815492+00	2026-02-17 15:34:28.552337+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	51dce4a8-bb3f-44ac-a264-b3837f289ead	authenticated	authenticated	user@gmx.com	$2a$10$..t1VWoo/GQs09fpltmqP.t6Fg4SMm0164cm7GidqECXMz3TptMEG	2026-02-16 10:50:02.740568+00	\N		\N		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-02-16 10:50:02.707941+00	2026-02-16 10:50:02.743313+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	e7450c22-ab44-440a-bfb7-bc14a9defb05	authenticated	authenticated	\N		\N	\N		\N		\N			\N	2026-02-16 18:05:19.262662+00	{}	{}	\N	2026-02-16 18:05:19.239884+00	2026-02-16 18:05:19.277394+00	\N	\N			\N		0	\N		\N	f	\N	t
00000000-0000-0000-0000-000000000000	b39d5058-550b-4640-b1c8-a821160cb061	authenticated	authenticated	newuser@mail.com	$2a$10$esJwLXSznaRGqxQB3F0jS.KVZPGTtAbxhnygeu.2IjtoPRfh1jpv6	2026-02-16 10:55:55.287691+00	\N		\N		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-02-16 10:55:55.271255+00	2026-02-16 10:55:55.291541+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	31536e18-7556-4d82-b41c-2ece065db4dc	authenticated	authenticated	\N		\N	\N		\N		\N			\N	2026-02-16 18:06:02.24233+00	{}	{}	\N	2026-02-16 18:06:02.232813+00	2026-02-16 18:06:02.244103+00	\N	\N			\N		0	\N		\N	f	\N	t
00000000-0000-0000-0000-000000000000	849e4383-8caf-420f-a13d-4e3393ee4645	authenticated	authenticated	klaus@tester.de	$2a$10$gGkOd2Pol/Ea0a0.AnaYo.9Vr4AZrUSfm4Eo8kpBSGYdzL5sb7EqW	2026-03-05 10:10:38.071471+00	\N		\N		\N			\N	2026-03-10 15:08:28.740017+00	{"provider": "email", "providers": ["email"]}	{"sub": "849e4383-8caf-420f-a13d-4e3393ee4645", "email": "klaus@tester.de", "display_name": "klaus", "email_verified": true, "phone_verified": false}	\N	2026-03-05 10:10:37.971196+00	2026-03-10 15:08:28.761997+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	5d3560c5-3d76-4606-80e8-7eb69ce36a51	authenticated	authenticated	\N		\N	\N		\N		\N			\N	2026-02-16 19:02:59.348402+00	{}	{}	\N	2026-02-16 19:02:59.174438+00	2026-02-16 19:02:59.412603+00	\N	\N			\N		0	\N		\N	f	\N	t
00000000-0000-0000-0000-000000000000	db2eea71-c184-41bb-84bf-e6bb40c770fd	authenticated	authenticated	\N		\N	\N		\N		\N			\N	2026-02-16 19:04:05.93316+00	{}	{}	\N	2026-02-16 19:04:05.92591+00	2026-02-16 19:04:05.942331+00	\N	\N			\N		0	\N		\N	f	\N	t
00000000-0000-0000-0000-000000000000	560902da-285b-493c-8d46-16be17996519	authenticated	authenticated	info@vadimcebanu.dev	$2a$10$disbkTpfWIPneNfzx7c.V.jOhRqGtXaaC3/RgyTFZrkYd/CBjnWS.	2026-02-16 09:24:00.090493+00	\N		\N		\N			\N	2026-03-06 10:36:00.929129+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-02-16 09:24:00.060986+00	2026-03-06 10:36:00.933809+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	authenticated	authenticated	serhatozcakir35@gmail.com	$2a$10$qRWxW3mPlB8wC7HJBq6fr.nxNXJhKK54AJRGwBBOt7Mi39rQiaSBC	2026-02-16 09:27:03.164832+00	\N		\N		\N			\N	2026-03-09 12:10:48.717602+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-02-16 09:27:03.156426+00	2026-03-10 14:13:37.296634+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	2bb9bfb9-e2ac-41e9-9c2f-fbfa2c928de5	authenticated	authenticated	uasea@mail.de	$2a$10$myhhe4/UynwKC7wm/PVjuuVYYzzTvJ1CipcQOhZqeLKb/2ASGS4Ui	\N	\N	ea9bb0467fa5e2d576629d573efef85b4659660202235bd6546716ac	2026-02-17 11:00:46.389777+00		\N			\N	\N	{"provider": "email", "providers": ["email"]}	{"sub": "2bb9bfb9-e2ac-41e9-9c2f-fbfa2c928de5", "email": "uasea@mail.de", "display_name": "vadim cebanu", "email_verified": false, "phone_verified": false}	\N	2026-02-17 11:00:46.385099+00	2026-02-17 11:00:46.980097+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	authenticated	authenticated	vadykdeejay@gmail.com	$2a$10$ApxRnz3zkNqy/VGM4CanwueB8wkUVXI8KmhnE5m/j7FUdtjf4tqVm	2026-02-17 11:02:29.36788+00	\N		\N		\N			\N	2026-03-11 07:17:19.47255+00	{"provider": "email", "providers": ["email"]}	{"sub": "9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1", "email": "vadykdeejay@gmail.com", "display_name": "vadim cebanu", "email_verified": true, "phone_verified": false}	\N	2026-02-17 11:02:29.14834+00	2026-03-11 07:20:55.031602+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	d071f9b2-ce73-44a2-b015-2a2d8efe1503	authenticated	authenticated	b.blarr@gmx.de	$2a$10$G5vJMskAWAFRFbexyod9KuLqdSp2LoH9vRM3C8Zzh1AmSlkbj7ihC	2026-02-16 09:26:42.11442+00	\N		\N		\N			\N	2026-03-10 14:13:43.58798+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-02-16 09:26:42.10826+00	2026-03-10 14:13:43.592448+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	312fbd38-46b4-4611-bf01-ea5b58854967	authenticated	authenticated	vadykdeejay@mail.com	$2a$10$0FPK0RqY1utH4lV2dpctWuLegDsTHHU8UOZ1V8GDEwuKLJI/W4VKa	2026-02-17 14:25:19.779507+00	\N		\N		\N			\N	2026-02-17 14:25:19.790606+00	{"provider": "email", "providers": ["email"]}	{"sub": "312fbd38-46b4-4611-bf01-ea5b58854967", "email": "vadykdeejay@mail.com", "display_name": "vadim cebanu", "email_verified": true, "phone_verified": false}	\N	2026-02-17 14:25:19.765952+00	2026-02-17 14:25:19.795967+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	9852c5b1-e17b-402e-81fa-6b638f610264	authenticated	authenticated	\N		\N	\N		\N		\N			\N	2026-02-17 08:30:14.395379+00	{}	{}	\N	2026-02-17 08:30:14.358355+00	2026-02-17 10:30:08.871267+00	\N	\N			\N		0	\N		\N	f	\N	t
00000000-0000-0000-0000-000000000000	c4ec5e93-766d-48c2-8312-8c673287fbd9	authenticated	authenticated	za.gr@web.de	$2a$10$AYLMwqLxeC324mcqqWGi5eSYtvOE5UAIX70ipE9CxI6WOm0gowBnO	2026-02-16 09:26:13.218772+00	\N		\N		\N			\N	2026-03-08 20:40:55.405579+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-02-16 09:26:13.209517+00	2026-03-08 20:40:55.48254+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	306b5d39-a4ee-4848-a64a-01ad4ffa241d	authenticated	authenticated	giuliano@da.de	$2a$10$o0d2qqN7fEWf/hOioSi0Iuy3G9O1Lk9VQUozIUDrSsp4tgpwLVNWq	2026-02-16 10:57:09.513022+00	\N		\N		\N			\N	2026-03-06 19:09:42.164694+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-02-16 10:57:09.504967+00	2026-03-06 19:09:42.167079+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	b0187f61-fe65-436d-a9f8-dc1a2b4d307e	authenticated	authenticated	mario@mail.de	$2a$10$mQZB8QMmf0wHh5QH0mVUJOCKtsBhEx9Amx0z/5mW6xDqgo8pU7pP.	2026-03-09 10:27:30.56011+00	\N		\N		\N			\N	2026-03-09 10:27:30.564072+00	{"provider": "email", "providers": ["email"]}	{"sub": "b0187f61-fe65-436d-a9f8-dc1a2b4d307e", "email": "mario@mail.de", "display_name": "mario", "email_verified": true, "phone_verified": false}	\N	2026-03-09 10:27:30.538587+00	2026-03-09 10:27:30.570965+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	da0ff70f-fb32-418b-b84f-f66d7fcf6685	authenticated	authenticated	vadykdeejay@gmail.comwer	$2a$10$gotJGhaSYJM5uSc7gGSpEeMX8XvrOQcwx2q5OnB3PeWz8I21ivCXi	2026-03-06 16:03:28.223926+00	\N		\N		\N			\N	2026-03-06 16:03:28.234546+00	{"provider": "email", "providers": ["email"]}	{"sub": "da0ff70f-fb32-418b-b84f-f66d7fcf6685", "email": "vadykdeejay@gmail.comwer", "display_name": "vadim cebanu", "email_verified": true, "phone_verified": false}	\N	2026-03-06 16:03:28.183125+00	2026-03-06 16:03:28.238994+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	3f062642-a3ec-45c2-be36-4b05fe0b5235	authenticated	authenticated	vadim34@mail.de	$2a$10$V.HQAGttyBl6t94rYxdm1eAgeEa94atz1DKNqxPO7o/iXfaQsaePS	2026-03-05 19:13:18.456865+00	\N		\N		\N			\N	2026-03-05 19:13:18.462765+00	{"provider": "email", "providers": ["email"]}	{"sub": "3f062642-a3ec-45c2-be36-4b05fe0b5235", "email": "vadim34@mail.de", "display_name": "vadim cebanu", "email_verified": true, "phone_verified": false}	\N	2026-03-05 19:13:18.451911+00	2026-03-05 19:13:18.466687+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	21f90788-2d49-4547-b867-d52455e0d56b	authenticated	authenticated	vadim@mail.dee	$2a$10$47kizdBHxsblcyhYrZa2sOva/S7Vu4bPqWO0eQ3IYIYzuf4S6dmM2	2026-03-05 19:09:07.500961+00	\N		\N		\N			\N	2026-03-05 19:09:07.507583+00	{"provider": "email", "providers": ["email"]}	{"sub": "21f90788-2d49-4547-b867-d52455e0d56b", "email": "vadim@mail.dee", "display_name": "vadim cebanu", "email_verified": true, "phone_verified": false}	\N	2026-03-05 19:09:07.484497+00	2026-03-05 19:09:07.51308+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	1c0f7c19-3851-4429-91c9-6b8d67d4e7b7	authenticated	authenticated	marrio@mgail.de	$2a$10$80mLcKMO9jcEcUxOMs5LWOcHphEdQNkCOUi5xdygTj.XpnxrYkMVS	2026-03-09 10:32:02.819151+00	\N		\N		\N			\N	2026-03-09 10:32:02.822745+00	{"provider": "email", "providers": ["email"]}	{"sub": "1c0f7c19-3851-4429-91c9-6b8d67d4e7b7", "email": "marrio@mgail.de", "display_name": "marrio", "email_verified": true, "phone_verified": false}	\N	2026-03-09 10:32:02.807835+00	2026-03-09 10:32:02.828028+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	3a846c33-7c2d-4ec2-9fe5-ff4eaa092dcc	authenticated	authenticated	vadim@mail.de	$2a$10$6Js8ONm6oclKMRZnvJeJc.15AM4Co9.rvKbaxbdMyqBBEYGzzvzlO	2026-03-05 19:05:52.837536+00	\N		\N		\N			\N	2026-03-05 19:23:54.871857+00	{"provider": "email", "providers": ["email"]}	{"sub": "3a846c33-7c2d-4ec2-9fe5-ff4eaa092dcc", "email": "vadim@mail.de", "display_name": "vadim cebanu", "email_verified": true, "phone_verified": false}	\N	2026-03-05 19:05:52.782179+00	2026-03-06 11:07:43.537538+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	8642c8b5-f0b9-4811-8f7a-425155de9d1d	authenticated	authenticated	vadim@gmail.de	$2a$10$aQ82fDsSZwJ2kCqdno4qWOG.1NASso98MH7twhIegjRfHae817.rC	2026-03-05 19:12:42.332915+00	\N		\N		\N			\N	2026-03-05 19:12:42.338265+00	{"provider": "email", "providers": ["email"]}	{"sub": "8642c8b5-f0b9-4811-8f7a-425155de9d1d", "email": "vadim@gmail.de", "display_name": "vadim cebanu", "email_verified": true, "phone_verified": false}	\N	2026-03-05 19:12:42.324719+00	2026-03-05 19:12:42.343254+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	092175d3-fa6b-4b6d-9a62-67a547151b5c	authenticated	authenticated	uaseea@mgail.de	$2a$10$Ymbq0NScYItYwzByklYX3.BqEakiZEZ9POtvfQFkWwMZvHgyNfUZe	2026-03-09 10:23:51.717949+00	\N		\N		\N			\N	2026-03-09 10:23:51.75465+00	{"provider": "email", "providers": ["email"]}	{"sub": "092175d3-fa6b-4b6d-9a62-67a547151b5c", "email": "uaseea@mgail.de", "display_name": "uasea", "email_verified": true, "phone_verified": false}	\N	2026-03-09 10:23:51.616747+00	2026-03-09 10:23:51.766299+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	14c5bf86-010f-4355-b352-200ddc0c4aee	authenticated	authenticated	meyer@mail.de	$2a$10$S0rIiEQwA0DzPMQojLACnuxmDRY9ZjL.GT6EheWNjTCVHiWxGjhCe	2026-03-07 07:42:51.918143+00	\N		\N		\N			\N	2026-03-07 07:43:25.665926+00	{"provider": "email", "providers": ["email"]}	{"sub": "14c5bf86-010f-4355-b352-200ddc0c4aee", "email": "meyer@mail.de", "display_name": "Peter Meyer", "email_verified": true, "phone_verified": false}	\N	2026-03-07 07:42:51.895155+00	2026-03-07 07:43:25.672001+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	993dc109-8d6c-4369-8011-8b39b0059830	authenticated	authenticated	vadyk@mail.com	$2a$10$uYSb.e.0ZmoEz0rd6SrHheOVx0pU.IG3Cg9upbz2OWq9F24ZRyEG2	2026-03-09 09:01:18.22135+00	\N		\N		\N			\N	2026-03-09 09:01:18.246563+00	{"provider": "email", "providers": ["email"]}	{"sub": "993dc109-8d6c-4369-8011-8b39b0059830", "email": "vadyk@mail.com", "display_name": "vadim cebanu", "email_verified": true, "phone_verified": false}	\N	2026-03-09 09:01:18.120375+00	2026-03-09 09:01:18.298112+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	b6ccc057-3ea9-4e5f-89b0-d28e37acb208	authenticated	authenticated	vadykdeejay@gmail.comqweq	$2a$10$VDxWFCVs.JOPuOywjSZi4O8OU/U30zxoi0sPh8hQVFL0xAPr4nF06	2026-03-06 16:05:08.986247+00	\N		\N		\N			\N	2026-03-06 16:05:08.989613+00	{"provider": "email", "providers": ["email"]}	{"sub": "b6ccc057-3ea9-4e5f-89b0-d28e37acb208", "email": "vadykdeejay@gmail.comqweq", "display_name": "vadim cebanu", "email_verified": true, "phone_verified": false}	\N	2026-03-06 16:05:08.973635+00	2026-03-06 16:05:08.9959+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	73ebb754-d8b0-46d2-bea9-846fa82d3657	authenticated	authenticated	alladin@mail.de	$2a$10$lJ0TSnh5DyEYpK0DTPhWpu.UU4IUrLzyNhZzktoJNqwDqeDWzXg/K	2026-03-09 10:25:40.953091+00	\N		\N		\N			\N	2026-03-09 10:25:40.960293+00	{"provider": "email", "providers": ["email"]}	{"sub": "73ebb754-d8b0-46d2-bea9-846fa82d3657", "email": "alladin@mail.de", "display_name": "alladin", "email_verified": true, "phone_verified": false}	\N	2026-03-09 10:25:40.932626+00	2026-03-09 10:25:40.980495+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	924c7e03-fc42-479c-b841-c7eaa607cdc6	authenticated	authenticated	zar.gr@web.de	$2a$10$wVOlkFEuR.uks7qOT9zAEeR0q77MtAaKv6fLU911w/REsm9gCHurO	2026-03-09 08:09:54.08274+00	\N		\N		\N			\N	2026-03-09 08:10:11.174834+00	{"provider": "email", "providers": ["email"]}	{"sub": "924c7e03-fc42-479c-b841-c7eaa607cdc6", "email": "zar.gr@web.de", "display_name": "Gregor Zar", "email_verified": true, "phone_verified": false}	\N	2026-03-09 08:09:54.052027+00	2026-03-09 21:25:03.994674+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	bcefc261-a2e7-4936-80c7-ff01bf33cb38	authenticated	authenticated	aladinnn@mail.de	$2a$10$0D5NyyYfs0P6XBkhvBkn1O/rv5Sp0ErjA1HoyFt8yMNHJDyD5AXTq	2026-03-09 10:34:50.982001+00	\N		\N		\N			\N	2026-03-09 10:34:50.994388+00	{"provider": "email", "providers": ["email"]}	{"sub": "bcefc261-a2e7-4936-80c7-ff01bf33cb38", "email": "aladinnn@mail.de", "display_name": "alladin", "email_verified": true, "phone_verified": false}	\N	2026-03-09 10:34:50.923508+00	2026-03-09 10:34:51.017968+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	0934afbd-f66b-4497-b251-4dbab6283576	authenticated	authenticated	klaus@tester2.de	$2a$10$pcqt18Qiiv35clzrG915Pe1w7jRs7Z8Bv7tgGAm0DI8DnQBJSdgNe	2026-03-10 15:02:52.315159+00	\N		\N		\N			\N	2026-03-10 15:02:52.326067+00	{"provider": "email", "providers": ["email"]}	{"sub": "0934afbd-f66b-4497-b251-4dbab6283576", "email": "klaus@tester2.de", "display_name": "KlausDerZweite", "email_verified": true, "phone_verified": false}	\N	2026-03-10 15:02:52.278841+00	2026-03-10 15:02:52.331721+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	c14fea5b-d484-4c2f-b022-c5ed8a34a2c1	authenticated	authenticated	alladin@web.de	$2a$10$1laQsdw0eam1MZPF19K5X.wtyhGrcL8ht4Oj1UePKkAdwM.txmooa	2026-03-10 15:59:29.63657+00	\N		\N		\N			\N	2026-03-10 15:59:29.647843+00	{"provider": "email", "providers": ["email"]}	{"sub": "c14fea5b-d484-4c2f-b022-c5ed8a34a2c1", "email": "alladin@web.de", "display_name": "alladin", "email_verified": true, "phone_verified": false}	\N	2026-03-10 15:59:29.593998+00	2026-03-10 15:59:29.665817+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	75f39917-51d9-4aa7-bdc6-7466cd70daf0	authenticated	authenticated	111111111111111111111111111111111111111111111111111112@1.de	$2a$10$ha5rJSzCIY/wEiEsNLKJYeDSnjpV0NKeT4HPPy6fmgrpzQDTJA.9K	2026-03-09 13:50:27.391656+00	\N		\N		\N			\N	2026-03-09 13:50:27.394948+00	{"provider": "email", "providers": ["email"]}	{"sub": "75f39917-51d9-4aa7-bdc6-7466cd70daf0", "email": "111111111111111111111111111111111111111111111111111112@1.de", "display_name": "111111111111111111111111111111111111111111111111111111111111111111111111111", "email_verified": true, "phone_verified": false}	\N	2026-03-09 13:50:27.383979+00	2026-03-09 13:50:27.399635+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	22ca59ca-9978-4986-a24b-38251f8e78e2	authenticated	authenticated	peterm@peter.de	$2a$10$9Em8BDcC0PyUawi89M5gzeEOT/GwfN/Qko3RcouegqJ1fxY74DgjC	2026-03-09 13:46:13.655486+00	\N		\N		\N			\N	2026-03-09 13:46:13.675027+00	{"provider": "email", "providers": ["email"]}	{"sub": "22ca59ca-9978-4986-a24b-38251f8e78e2", "email": "peterm@peter.de", "display_name": "Peter Meyerdfdsfdfsdfsdfdsfsdfdsfsdfsdfsdf", "email_verified": true, "phone_verified": false}	\N	2026-03-09 13:46:13.553509+00	2026-03-09 13:46:13.707249+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	ff94c710-a33a-498c-a6a6-6ce84f1977fc	authenticated	authenticated	mario@web.de	$2a$10$QarjSv7Ixgx5k6L3R8Dwf.W/AsF43PQ1MddPjAZRdWKKTPRlx0vOC	2026-03-10 15:45:09.505525+00	\N		\N		\N			\N	2026-03-10 15:45:09.520252+00	{"provider": "email", "providers": ["email"]}	{"sub": "ff94c710-a33a-498c-a6a6-6ce84f1977fc", "email": "mario@web.de", "display_name": "mario", "email_verified": true, "phone_verified": false}	\N	2026-03-10 15:45:09.438541+00	2026-03-10 15:45:09.575278+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	217a05cc-7709-4e39-a0cf-ede8b02d87a4	authenticated	authenticated	12@1.de	$2a$10$8QcfWk0Mv1L9hN/e1qXc8OEq7ioM.nrcKlrDfJIr5ctdjWcNdagjW	2026-03-09 13:48:09.287389+00	\N		\N		\N			\N	2026-03-09 13:48:09.290134+00	{"provider": "email", "providers": ["email"]}	{"sub": "217a05cc-7709-4e39-a0cf-ede8b02d87a4", "email": "12@1.de", "display_name": "A", "email_verified": true, "phone_verified": false}	\N	2026-03-09 13:48:09.267575+00	2026-03-09 13:48:09.295383+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	9647ef90-fd59-4dde-8a76-26668af98700	authenticated	authenticated	alladdin@web.de	$2a$10$1Z2jY3ZTjsjHMnjWbxJeh.4hzecsqIDltPFCtWg0OZxmWhokpSAMS	2026-03-10 16:00:11.019231+00	\N		\N		\N			\N	2026-03-10 16:00:11.021477+00	{"provider": "email", "providers": ["email"]}	{"sub": "9647ef90-fd59-4dde-8a76-26668af98700", "email": "alladdin@web.de", "display_name": "alladin", "email_verified": true, "phone_verified": false}	\N	2026-03-10 16:00:11.013351+00	2026-03-10 16:00:11.023824+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	abc33f51-f7fe-45aa-ba58-71be49d0cf4f	authenticated	authenticated	klausi@web.de	$2a$10$VRn8CjEsqHy/znaDoY0ulu0PRBPgknYt3xmq2bA/Liqi2X9BUKwJW	2026-03-11 09:27:36.53067+00	\N		\N		\N			\N	2026-03-11 09:27:36.538639+00	{"provider": "email", "providers": ["email"]}	{"sub": "abc33f51-f7fe-45aa-ba58-71be49d0cf4f", "email": "klausi@web.de", "display_name": "klausi", "email_verified": true, "phone_verified": false}	\N	2026-03-11 09:27:36.501608+00	2026-03-11 09:27:36.544887+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	750436b2-3280-4fc1-88a6-92cdee4b774c	authenticated	authenticated	hannikohl@web.de	$2a$10$VG04EVm3ZOvHEavQtiZzOuhrVNrF2PUcQzaG/qWBMARK.p49uyDgy	2026-03-11 08:14:59.03352+00	\N		\N		\N			\N	2026-03-11 08:14:59.048779+00	{"provider": "email", "providers": ["email"]}	{"sub": "750436b2-3280-4fc1-88a6-92cdee4b774c", "email": "hannikohl@web.de", "display_name": "Hannelore Kohl", "email_verified": true, "phone_verified": false}	\N	2026-03-11 08:14:58.954034+00	2026-03-11 08:14:59.102916+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	fdaf6d5b-b6de-4dcb-bcb5-fbf0276736bf	authenticated	authenticated	klausderzwoelfte@web.de	$2a$10$XOSnkmokWZu8N2UB0vhDqOpwzVOy2faolpoflzUjXMwnLd9xfqib2	2026-03-10 15:21:08.331676+00	\N		\N		\N			\N	2026-03-10 15:21:08.347949+00	{"provider": "email", "providers": ["email"]}	{"sub": "fdaf6d5b-b6de-4dcb-bcb5-fbf0276736bf", "email": "klausderzwoelfte@web.de", "display_name": "klausder zwölfte", "email_verified": true, "phone_verified": false}	\N	2026-03-10 15:21:08.278824+00	2026-03-11 09:26:32.234278+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: contacts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.contacts (id, user_id, name, email, phone, created_at) FROM stdin;
b093bfb7-d409-4a84-8aa1-cd174a9866ca	d071f9b2-ce73-44a2-b015-2a2d8efe1503	Benjamin Blarr	b.blarr@gmx.de	34567889	2026-02-25 08:28:24.948851+00
f1095bee-d4ab-438c-9d52-39665e8f9c88	05e11232-a2be-4a94-aa31-fe8bbdfa9b23	Mark Müller	Mark@gmail.com	+39586922294	2026-02-19 07:54:27.30656+00
20d9a60d-208a-4f4d-a9f2-7760b13c81af	\N	Ulf Kirsten	ulf.kirsten@gmx.com	02179744032	2026-02-17 11:12:02.283942+00
91c2abdf-ced0-42f1-9694-7aca31860993	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	Vadim Cebanu	vadykdeeja@gmail.com	015175984788	2026-02-18 14:45:16.165225+00
77021d33-03ae-4e55-ac46-f068b5594db9	d071f9b2-ce73-44a2-b015-2a2d8efe1503	Anni Berge	anni.berger@web.de	04329801	2026-02-20 14:12:58.862072+00
816ac477-bb70-4425-a7ea-a814394e618c	\N	Peter Meyer	peterm@t-online.de	017835553343	2026-03-05 10:51:05.86235+00
0450c92a-b258-404f-965a-7136a9ebaea9	\N	Serhat Özcakir	serhat35@gmail.com	+44909210192	2026-02-17 11:12:02.283942+00
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.profiles (id, email, display_name, created_at) FROM stdin;
2bb9bfb9-e2ac-41e9-9c2f-fbfa2c928de5	uasea@mail.de	vadim cebanu	2026-02-17 11:00:46.384789+00
9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	vadykdeejay@gmail.com	vadim cebanu	2026-02-17 11:02:29.141394+00
312fbd38-46b4-4611-bf01-ea5b58854967	vadykdeejay@mail.com	vadim cebanu	2026-02-17 14:25:19.764851+00
849e4383-8caf-420f-a13d-4e3393ee4645	klaus@tester.de	klaus	2026-03-05 10:10:37.968335+00
3a846c33-7c2d-4ec2-9fe5-ff4eaa092dcc	vadim@mail.de	vadim cebanu	2026-03-05 19:05:52.781829+00
21f90788-2d49-4547-b867-d52455e0d56b	vadim@mail.dee	vadim cebanu	2026-03-05 19:09:07.482836+00
8642c8b5-f0b9-4811-8f7a-425155de9d1d	vadim@gmail.de	vadim cebanu	2026-03-05 19:12:42.324389+00
3f062642-a3ec-45c2-be36-4b05fe0b5235	vadim34@mail.de	vadim cebanu	2026-03-05 19:13:18.451549+00
05e11232-a2be-4a94-aa31-fe8bbdfa9b23	serhatozcakir35@gmail.com	serhat ozcakir	2026-02-17 13:17:05.275437+00
306b5d39-a4ee-4848-a64a-01ad4ffa241d	giuliano@da.de	giuliano gioia	2026-02-17 13:17:05.275437+00
da0ff70f-fb32-418b-b84f-f66d7fcf6685	vadykdeejay@gmail.comwer	vadim cebanu	2026-03-06 16:03:28.182782+00
b6ccc057-3ea9-4e5f-89b0-d28e37acb208	vadykdeejay@gmail.comqweq	vadim cebanu	2026-03-06 16:05:08.973302+00
d071f9b2-ce73-44a2-b015-2a2d8efe1503	b.blarr@gmx.de	Benjamin Blarr	2026-02-17 13:17:05.275437+00
924c7e03-fc42-479c-b841-c7eaa607cdc6	zar.gr@web.de	Gregor Zar	2026-03-09 08:09:54.051665+00
993dc109-8d6c-4369-8011-8b39b0059830	vadyk@mail.com	vadim cebanu	2026-03-09 09:01:18.116453+00
092175d3-fa6b-4b6d-9a62-67a547151b5c	uaseea@mgail.de	uasea	2026-03-09 10:23:51.611032+00
73ebb754-d8b0-46d2-bea9-846fa82d3657	alladin@mail.de	alladin	2026-03-09 10:25:40.932285+00
b0187f61-fe65-436d-a9f8-dc1a2b4d307e	mario@mail.de	mario	2026-03-09 10:27:30.537541+00
1c0f7c19-3851-4429-91c9-6b8d67d4e7b7	marrio@mgail.de	marrio	2026-03-09 10:32:02.807485+00
bcefc261-a2e7-4936-80c7-ff01bf33cb38	aladinnn@mail.de	alladin	2026-03-09 10:34:50.922555+00
217a05cc-7709-4e39-a0cf-ede8b02d87a4	12@1.de	A	2026-03-09 13:48:09.267248+00
0934afbd-f66b-4497-b251-4dbab6283576	klaus@tester2.de	KlausDerZweite	2026-03-10 15:02:52.277249+00
fdaf6d5b-b6de-4dcb-bcb5-fbf0276736bf	klausderzwoelfte@web.de	klausder zwölfte	2026-03-10 15:21:08.276958+00
ff94c710-a33a-498c-a6a6-6ce84f1977fc	mario@web.de	mario	2026-03-10 15:45:09.430782+00
c14fea5b-d484-4c2f-b022-c5ed8a34a2c1	alladin@web.de	alladin	2026-03-10 15:59:29.592942+00
9647ef90-fd59-4dde-8a76-26668af98700	alladdin@web.de	alladin	2026-03-10 16:00:11.013018+00
750436b2-3280-4fc1-88a6-92cdee4b774c	hannikohl@web.de	Hannelore Kohl	2026-03-11 08:14:58.95152+00
abc33f51-f7fe-45aa-ba58-71be49d0cf4f	klausi@web.de	klausi	2026-03-11 09:27:36.50126+00
\.


--
-- Data for Name: project_members; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.project_members (id, project_id, user_id, role, created_at) FROM stdin;
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.projects (id, name, description, owner_id, is_guest_project, guest_token, created_at) FROM stdin;
\.


--
-- Data for Name: task_comments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.task_comments (id, task_id, author_id, guest_token, body, created_at) FROM stdin;
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tasks (id, project_id, title, description, status, priority, created_by, guest_token, due_at, created_at, updated_at, assignees, subtasks, type, "position") FROM stdin;
c9abc566-f6ea-441b-be84-2643c3590d92	\N	sign up succes message 		inProgress	high	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	\N	2026-03-12 00:00:00+00	2026-03-06 17:59:41.324496+00	2026-03-06 17:59:41.324496+00	[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]	[]	User Story	0
e351ea1f-39d1-4e0f-967c-1daa718a31d0	\N	Authentication Service:	Zentraler Service für Login, Logout und Gast-Zugang.	done	high	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	\N	2026-03-12 00:00:00+00	2026-03-05 18:23:42.706825+00	2026-03-05 18:23:42.706825+00	[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]	[{"id": "c03ba5ea-4bf4-4ca3-b7fa-9a6333261c91", "done": true, "title": "Der eigene Account ist in der \\"Contacts\\"-Liste sichtbar."}, {"id": "068e573e-10a1-4ed2-ba93-80dfb21eb4f9", "done": true, "title": "Der eigene Kontakt kann wie jeder andere Kontakt bearbeitet werden."}]	Technical Task	0
1da55de8-2fab-44ee-8d5f-9872ab83afdb	\N	User Story -4		todo	medium	\N	\N	2026-03-12 00:00:00+00	2026-03-06 11:23:19.694141+00	2026-03-06 11:23:19.694141+00	[]	[]	User Story	0
48308fa9-4e95-4867-b499-3c75c8664ca9	\N	Greeting Message	when login , a greeting page must be created like in figma	done	high	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	\N	2026-03-12 00:00:00+00	2026-03-06 17:59:01.367292+00	2026-03-06 17:59:01.367292+00	[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]	[]	User Story	0
a2ee77cf-3806-4ed8-8fe8-2f0c975fd3d6	\N	Namentliche Begrüßung nicht Email		done	medium	d071f9b2-ce73-44a2-b015-2a2d8efe1503	\N	2026-03-12 00:00:00+00	2026-03-06 13:35:37.82648+00	2026-03-06 13:35:37.82648+00	[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]	[]	Technical Task	0
7f5f9f32-3a9e-4511-8fc3-920cb33d5c03	\N	remember option create	\N	done	medium	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	\N	2026-03-12 00:00:00+00	2026-03-09 10:04:03.577582+00	2026-03-09 10:04:03.577582+00	[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]	[]	Technical Task	0
46d9433e-68d8-436b-97ab-252bbc4ceec6	\N	Guest Login:	Ein spezieller Account, der vordefinierte Daten lädt, aber die gleichen Komponenten wie ein normaler User nutzt.	done	medium	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	\N	2026-03-07 00:00:00+00	2026-03-05 18:24:11.643866+00	2026-03-05 18:24:11.643866+00	[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]	[{"id": "5c0e367f-b9de-4102-893f-4591a9519142", "done": true, "title": "\\"Logout\\"-Option ist in der Benutzeroberfläche leicht findbar."}, {"id": "d14471fd-1efc-4784-9eec-e4f67d9a6c37", "done": true, "title": "Sicherer Logout und automatische Weiterleitung zum Login-Bildschirm."}, {"id": "164a208a-ad9f-4003-a551-4049681ef804", "done": true, "title": "Persönliche Daten sind ohne erneutes Login nicht mehr zugänglich."}, {"id": "27f622f1-481f-4bcb-a103-8c3e51cf9a56", "done": true, "title": "After signup automatic linked to login"}]	Technical Task	0
1d638547-0acb-41cc-8d0a-470667efd5e5	\N	Hilfe (Help)		done	low	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	\N	2026-03-07 00:00:00+00	2026-03-05 18:40:55.198262+00	2026-03-05 18:40:55.198262+00	[{"id": "0450c92a-b258-404f-965a-7136a9ebaea9", "name": "Serhat Özcakir", "initials": "SÖ"}]	[{"id": "748ae378-815b-4f82-98f5-3244735cc2f5", "done": true, "title": "Hilfe-Button im Header neben dem User-Icon."}, {"id": "fdb78aca-fdd8-4601-bda3-fe274ad72e41", "done": true, "title": "Informationsseite zur Funktionsweise des Kanban-Boards."}, {"id": "f7529992-4310-40c8-8403-0e5d79a8e8c3", "done": true, "title": "Zurück-Button, der zur letzten besuchten Seite führt."}]	Technical Task	0
3a3fe371-94f4-4a2c-99c1-2b6d755990ab	\N	Sidebar umbauen für nicht eingeloggte User		done	medium	\N	\N	2026-03-12 00:00:00+00	2026-03-06 06:25:46.382685+00	2026-03-06 06:25:46.382685+00	[{"id": "b093bfb7-d409-4a84-8aa1-cd174a9866ca", "name": "Benjamin Blarr", "initials": "BB"}]	[{"id": "80076ab8-927f-4bb3-a273-596f68d9d369", "done": true, "title": "if else Einbauen zur Unterscheidung der Bereiche"}, {"id": "263f0496-004d-44c2-9f27-065aa67b8dca", "done": true, "title": "HTML bauen"}, {"id": "f4841278-935e-4034-a973-d2089f491cbf", "done": true, "title": "Styling für Desktop"}, {"id": "f42cd983-7412-4e18-83c7-806749131b29", "done": true, "title": "Styling für Mobile"}, {"id": "1aafc69c-38da-4859-a52e-1ad4d1396878", "done": true, "title": "Responsiveness"}, {"id": "6be68aa8-09fa-424e-8d3b-63a5b1f973af", "done": true, "title": "Korrekte Verlinkung/Routing"}]	User Story	0
9c8631d0-dcde-42f1-9a07-afeacb82d8d5	\N	Responsiveness		done	medium	d071f9b2-ce73-44a2-b015-2a2d8efe1503	\N	2026-03-10 00:00:00+00	2026-03-07 08:45:43.883466+00	2026-03-07 08:45:43.883466+00	[{"id": "0450c92a-b258-404f-965a-7136a9ebaea9", "name": "Serhat Özcakir", "initials": "SÖ"}]	[{"id": "e0e0c58f-1088-4047-b869-4c3e65b3e741", "done": false, "title": "Login Page"}, {"id": "45aaf90d-fef7-4395-bdb3-f544eadfdd1d", "done": false, "title": "Submit Page"}, {"id": "da3ae339-5fb2-428f-a292-b4dcd55fbcaf", "done": false, "title": "Summary Page"}]	Technical Task	0
e1195a7b-b07a-4c8f-9b8d-277bd41fbc05	\N	User Story - 5		done	medium	\N	\N	2026-03-12 00:00:00+00	2026-03-06 11:24:22.581439+00	2026-03-06 11:24:22.581439+00	[]	[]	User Story	0
e87a7ec1-472e-4695-9220-0cd78bdc2335	\N	Header für nicht eingeloggte User bearbeiten	Buttons oben rechts dürfen nicht angezeigt werden	awaitFeedback	medium	d071f9b2-ce73-44a2-b015-2a2d8efe1503	\N	2026-03-12 00:00:00+00	2026-03-06 14:22:00.235559+00	2026-03-06 14:22:00.235559+00	[{"id": "b093bfb7-d409-4a84-8aa1-cd174a9866ca", "name": "Benjamin Blarr", "initials": "BB"}]	[]	User Story	0
a711ee34-09db-4d9b-800a-902114db6b46	\N	Mobile screen logo		awaitFeedback	medium	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	\N	2026-03-12 00:00:00+00	2026-03-09 10:23:11.013608+00	2026-03-09 10:23:11.013608+00	[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]	[]	User Story	0
a029f9ab-1a52-4c40-bca4-0c83f05e2659	\N	Impressum / Datenschutzerklärung		awaitFeedback	medium	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	\N	2026-03-07 00:00:00+00	2026-03-05 18:39:13.056237+00	2026-03-05 18:39:13.056237+00	[{"id": "b093bfb7-d409-4a84-8aa1-cd174a9866ca", "name": "Benjamin Blarr", "initials": "BB"}]	[{"id": "d30ca03b-7476-4851-92e5-1d27690b8ebc", "done": true, "title": "Bereich für Privacy Policy (Datenschutz) vorhanden (nutze einen Generator)."}, {"id": "c978426d-f3aa-43e8-97cb-e765c6ecfa84", "done": true, "title": "Sicherheit: Unangemeldete User sehen auf diesen Seiten keine Sidebar-Links zum Board."}, {"id": "e69818d4-0b3e-4f96-aee9-5470ac269d78", "done": true, "title": "Links auf der Login-Seite klickbar machen"}, {"id": "40dc73af-98cb-47f4-b925-8d2a6419553e", "done": true, "title": "Impressum schreiben"}, {"id": "1121dd2b-14ae-41d2-8ed3-951951dc725d", "done": true, "title": "Impressum stylen"}, {"id": "b51baff1-595d-4c3e-abd9-f72e520c5aa5", "done": true, "title": "Datenschutz schreiben"}, {"id": "f6ae8214-2a34-4a78-a873-365277e2a97e", "done": true, "title": "Datenschutz stylen"}]	Technical Task	0
c9a985df-c351-4a80-aabe-da8cc9117b42	\N	Reactive Forms oder Template-driven Forms	Nutze Angular Forms für die Registrierung/Login (inkl. Custom Validators für E-Mail & Passwort).	awaitFeedback	high	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	\N	2026-03-07 00:00:00+00	2026-03-05 18:21:50.150919+00	2026-03-05 18:21:50.150919+00	[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]	[{"id": "000a948b-e485-44bb-a050-15761ae49e48", "done": true, "title": "Registrierungsformular mit Feldern für: Name, E-Mail und Passwort."}, {"id": "2dc8b0b2-c740-462d-a238-fd47aaa90190", "done": true, "title": "Die Datenschutzerklärung muss vor Abschluss akzeptiert werden (Checkbox)."}, {"id": "6c090db6-0d12-43f1-90a2-fee72a6a8e40", "done": true, "title": "Fehlermeldungen bei ungültigen Eingaben (z. B. falsches E-Mail-Format)."}, {"id": "f13af8cf-35bd-4672-a72f-6ccd378a4d26", "done": true, "title": "Der \\"Registrieren\\"-Button ist deaktiviert, bis alle Pflichtfelder ausgefüllt sind."}]	Technical Task	0
119cb481-a392-4081-a6df-fbf30d7fc50a	\N	Passwort beim Login sichtbar/unsichtbar machen können	Im Figma sieht man das man das switchen kann zwischen sichtbar und verschlüsselt wenn man auf das Symbol rechts im Input klickt	done	medium	\N	\N	2026-03-10 00:00:00+00	2026-03-06 14:50:23.339004+00	2026-03-06 14:50:23.339004+00	[{"id": "b093bfb7-d409-4a84-8aa1-cd174a9866ca", "name": "Benjamin Blarr", "initials": "BB"}]	[{"id": "4411526e-0045-49dd-a9a9-15ad2d9d4762", "done": true, "title": "Icons wechseln beim Klick"}, {"id": "a7f3e0b9-b224-4cf3-bb30-d47777a8f5f4", "done": true, "title": "Schrift sichtbar/unsichtbar machen beim Klick"}]	User Story	0
28463534-8d1f-4c23-8b4a-32ad56f5edd7	\N	Priorities in Taskvorschau müssen immer angezeigt werden	Beim erstellen eines Tasks werden die Priorities nicht angezeigt wenn kein assignee hinzugefügt wurde	done	high	d071f9b2-ce73-44a2-b015-2a2d8efe1503	\N	2026-03-10 00:00:00+00	2026-03-07 08:47:12.51839+00	2026-03-07 08:47:12.51839+00	[{"id": "b093bfb7-d409-4a84-8aa1-cd174a9866ca", "name": "Benjamin Blarr", "initials": "BB"}]	[]	Technical Task	0
2d49d346-d61a-4340-b675-cefb3b56f3bb	\N	after sign up do not  automatic login	\N	awaitFeedback	medium	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	\N	2026-03-11 00:00:00+00	2026-03-10 15:44:19.211339+00	2026-03-10 15:44:19.211339+00	[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]	[]	Technical Task	0
11426196-6034-41d9-b184-995f25ef8079	\N	Due date Anzeige	Due date wird nicht bei allen Tasks angezeigt	done	high	d071f9b2-ce73-44a2-b015-2a2d8efe1503	\N	2026-03-07 00:00:00+00	2026-03-07 08:48:07.647708+00	2026-03-07 08:48:07.647708+00	[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]	[{"id": "65e4b511-57f3-446f-9eab-6125000e2e10", "done": true, "title": "check"}]	Technical Task	0
e6368b55-2998-4973-aeaf-8da019564b18	\N	animation starting page	\N	awaitFeedback	medium	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	\N	2026-03-12 00:00:00+00	2026-03-09 15:31:57.534107+00	2026-03-09 15:31:57.534107+00	[]	[]	Technical Task	0
dff03a52-5f6a-4f78-b04e-bcdf9ecd6389	\N	User story 2	Schütze Routen wie /board oder /summary vor unbefugtem Zugriff (Redirect zum Login).	awaitFeedback	high	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	\N	2026-03-07 00:00:00+00	2026-03-05 18:23:12.598046+00	2026-03-05 18:23:12.598046+00	[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]	[{"id": "43741e79-4541-4558-9931-489bc0a0ff16", "done": true, "title": "Login-Formular mit Feldern für E-Mail und Passwort."}, {"id": "82d6e694-d5d2-4cc9-870e-140d6b7104f6", "done": true, "title": "Fehlermeldung bei falscher Kombination (E-Mail/Passwort)."}, {"id": "aa28b193-ab12-48ed-8996-9af6820a7f32", "done": true, "title": "Gast-Login Option vorhanden."}, {"id": "f08a0634-0a76-4f8c-b092-000dbe534e52", "done": true, "title": "Wichtig: Registrierte User und Gäste sehen die gleichen Daten im Board und in den Kontakten."}, {"id": "95e91c5b-09c2-4d61-bff0-8be5f64d8c83", "done": true, "title": "Zugriffsschutz: Nicht angemeldete Besucher werden von geschützten Seiten (Summary, Board, Task, etc.) zur Login-Seite umgeleitet."}]	Technical Task	0
02951a63-a1c5-4eba-804a-60d99b7f0946	\N	Sign Up Page anpassen	Viele Styles müssen angepasst werden	done	medium	\N	\N	2026-03-12 00:00:00+00	2026-03-06 14:55:05.489325+00	2026-03-06 14:55:05.489325+00	[{"id": "b093bfb7-d409-4a84-8aa1-cd174a9866ca", "name": "Benjamin Blarr", "initials": "BB"}]	[{"id": "8c8ec3da-d21e-4af4-b25f-9a6eaea633ea", "done": true, "title": "Zurück Button implementieren"}, {"id": "27a4578a-49b4-49a7-9e30-0b1e41c3034f", "done": true, "title": "Styles anpassen"}]	User Story	0
fcd406de-3ae7-43df-aec0-fc400f665297	\N	Checkliste: Max 400 LOCs (Lines of Code) pro Datei		inProgress	high	\N	\N	2026-03-10 00:00:00+00	2026-03-10 06:50:25.692697+00	2026-03-10 06:50:25.692697+00	[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]	[]	Technical Task	0
f72dfc28-07ee-48ff-a169-369344ef994a	\N	Summary page scroll Problem		done	medium	\N	\N	2026-03-12 00:00:00+00	2026-03-06 11:48:15.953136+00	2026-03-06 11:48:15.953136+00	[{"id": "0450c92a-b258-404f-965a-7136a9ebaea9", "name": "Serhat Özcakir", "initials": "SÖ"}]	[]	User Story	0
7522a31e-0f04-4697-a820-2189d474fc78	\N	Dashboard (Summary)	/**\n * Ermittelt die Begrüßung basierend auf der aktuellen Uhrzeit.\n * @returns {string} Die passende Begrüßungsformel.\n */\ngetGreeting(): string {\n  const hour = new Date().getHours();\n  if (hour < 12) return 'Good morning';\n  if (hour < 18) return 'Good afternoon';\n  return 'Good evening';\n}	awaitFeedback	medium	9af8a2d1-ede8-4dc3-86db-23e7ea1d98f1	\N	2026-03-12 00:00:00+00	2026-03-05 18:37:51.821729+00	2026-03-05 18:37:51.821729+00	[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]	[{"id": "3a751c26-3c55-496f-b919-4a0b71be44d1", "done": true, "title": "Anzeige der Task-Anzahl pro Status (To Do, In Progress, Awaiting Feedback, Done)."}, {"id": "4addfea0-25b4-425f-8177-293123b53c17", "done": true, "title": "Anzeige der nächsten Deadline und der Anzahl der Aufgaben mit dieser Deadline."}, {"id": "8691196b-412c-48d0-853f-fc8606498df7", "done": true, "title": "Begrüßungsnachricht (z. B. \\"Good morning, [User]\\"), die sich nach der Tageszeit richtet."}]	User Story	0
0bec467f-4b10-41f7-a5c4-30454fc5e903	\N	Überprüfen: Eine Funktion ist maximal 14 Zeilen lang	Überprüfen und refactoring	done	high	\N	\N	2026-03-10 00:00:00+00	2026-03-10 06:49:57.367952+00	2026-03-10 06:49:57.367952+00	[{"id": "b093bfb7-d409-4a84-8aa1-cd174a9866ca", "name": "Benjamin Blarr", "initials": "BB"}]	[]	Technical Task	0
e0652e54-7b42-487a-9a42-761859e904c7	\N	Summary Pages Card Hover Effekt	The hover effect should be adapted according to the design.	done	medium	\N	\N	2026-03-12 00:00:00+00	2026-03-06 12:54:53.979821+00	2026-03-06 12:54:53.979821+00	[{"id": "0450c92a-b258-404f-965a-7136a9ebaea9", "name": "Serhat Özcakir", "initials": "SÖ"}]	[]	User Story	0
6027f508-0c6c-4b1b-bccb-6f949d7865fa	\N	JS Doc in allen TS Dateien		inProgress	medium	\N	\N	2026-03-10 00:00:00+00	2026-03-10 06:52:18.082551+00	2026-03-10 06:52:18.082551+00	[{"id": "91c2abdf-ced0-42f1-9694-7aca31860993", "name": "Vadim Cebanu", "initials": "VC"}]	[]	Technical Task	0
19e8336f-2564-40c1-bc5c-f9f66064b930	\N	User Story -3		todo	medium	\N	\N	2026-03-07 00:00:00+00	2026-03-06 11:21:17.160301+00	2026-03-06 11:21:17.160301+00	[]	[]	User Story	0
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-02-16 08:56:36
20211116045059	2026-02-16 08:56:36
20211116050929	2026-02-16 08:56:37
20211116051442	2026-02-16 08:56:37
20211116212300	2026-02-16 08:56:37
20211116213355	2026-02-16 08:56:37
20211116213934	2026-02-16 08:56:37
20211116214523	2026-02-16 08:56:37
20211122062447	2026-02-16 08:56:37
20211124070109	2026-02-16 08:56:37
20211202204204	2026-02-16 08:56:38
20211202204605	2026-02-16 08:56:38
20211210212804	2026-02-16 08:56:38
20211228014915	2026-02-16 08:56:38
20220107221237	2026-02-16 08:56:38
20220228202821	2026-02-16 08:56:39
20220312004840	2026-02-16 08:56:39
20220603231003	2026-02-16 08:56:39
20220603232444	2026-02-16 08:56:39
20220615214548	2026-02-16 08:56:39
20220712093339	2026-02-16 08:56:39
20220908172859	2026-02-16 08:56:39
20220916233421	2026-02-16 08:56:40
20230119133233	2026-02-16 08:56:40
20230128025114	2026-02-16 08:56:40
20230128025212	2026-02-16 08:56:40
20230227211149	2026-02-16 08:56:40
20230228184745	2026-02-16 08:56:40
20230308225145	2026-02-16 08:56:40
20230328144023	2026-02-16 08:56:41
20231018144023	2026-02-16 08:56:41
20231204144023	2026-02-16 08:56:41
20231204144024	2026-02-16 08:56:41
20231204144025	2026-02-16 08:56:41
20240108234812	2026-02-16 08:56:41
20240109165339	2026-02-16 08:56:41
20240227174441	2026-02-16 08:56:42
20240311171622	2026-02-16 08:56:42
20240321100241	2026-02-16 08:56:42
20240401105812	2026-02-16 08:56:42
20240418121054	2026-02-16 08:56:43
20240523004032	2026-02-16 08:56:43
20240618124746	2026-02-16 08:56:43
20240801235015	2026-02-16 08:56:43
20240805133720	2026-02-16 08:56:43
20240827160934	2026-02-16 08:56:44
20240919163303	2026-02-16 08:56:44
20240919163305	2026-02-16 08:56:44
20241019105805	2026-02-16 08:56:44
20241030150047	2026-02-16 08:56:44
20241108114728	2026-02-16 08:56:45
20241121104152	2026-02-16 08:56:45
20241130184212	2026-02-16 08:56:45
20241220035512	2026-02-16 08:56:45
20241220123912	2026-02-16 08:56:45
20241224161212	2026-02-16 08:56:45
20250107150512	2026-02-16 08:56:45
20250110162412	2026-02-16 08:56:46
20250123174212	2026-02-16 08:56:46
20250128220012	2026-02-16 08:56:46
20250506224012	2026-02-16 08:56:46
20250523164012	2026-02-16 08:56:46
20250714121412	2026-02-16 08:56:46
20250905041441	2026-02-16 08:56:46
20251103001201	2026-02-16 08:56:46
20251120212548	2026-02-16 08:56:47
20251120215549	2026-02-16 08:56:47
20260218120000	2026-02-27 14:47:56
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
avatars	avatars	\N	2026-02-17 15:32:58.658001+00	2026-02-17 15:32:58.658001+00	t	f	1048576	\N	\N	STANDARD
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
test	ANALYTICS	ICEBERG	2026-02-17 15:47:21.111705+00	2026-02-17 15:47:21.111705+00	fe7c2729-198b-4df7-8964-a1263f31dea6	\N
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-02-16 03:35:27.037991
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-02-16 03:35:27.081684
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-02-16 03:35:27.089038
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-02-16 03:35:27.138147
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-02-16 03:35:27.260837
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-02-16 03:35:27.267494
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-02-16 03:35:27.278536
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-02-16 03:35:27.286919
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-02-16 03:35:27.297427
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-02-16 03:35:27.304703
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-02-16 03:35:27.31345
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-02-16 03:35:27.320161
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-02-16 03:35:27.330911
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-02-16 03:35:27.339803
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-02-16 03:35:27.346663
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-02-16 03:35:27.377719
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-02-16 03:35:27.38344
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-02-16 03:35:27.389099
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-02-16 03:35:27.39486
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-02-16 03:35:27.409909
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-02-16 03:35:27.415387
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-02-16 03:35:27.424965
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-02-16 03:35:27.444656
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-02-16 03:35:27.456011
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-02-16 03:35:27.461752
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-02-16 03:35:27.467046
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-02-16 03:35:27.472525
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-02-16 03:35:27.477982
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-02-16 03:35:27.48296
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-02-16 03:35:27.488092
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-02-16 03:35:27.49312
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-02-16 03:35:27.497989
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-02-16 03:35:27.50287
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-02-16 03:35:27.507792
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-02-16 03:35:27.512922
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-02-16 03:35:27.518156
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-02-16 03:35:27.523115
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-02-16 03:35:27.528093
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-02-16 03:35:27.534285
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-02-16 03:35:27.548937
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-02-16 03:35:27.554733
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-02-16 03:35:27.560178
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-02-16 03:35:27.565541
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-02-16 03:35:27.570654
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-02-16 03:35:27.575682
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-02-16 03:35:27.581529
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-02-16 03:35:27.591613
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-02-16 03:35:27.597502
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-02-16 03:35:27.602771
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-02-16 03:35:27.624739
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-02-16 03:35:27.630822
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-02-16 03:35:28.498438
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-02-16 03:35:28.500145
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-02-16 03:35:28.515507
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-02-16 03:35:28.519912
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-02-16 03:35:28.521773
56	fix-optimized-search-function	cb58526ebc23048049fd5bf2fd148d18b04a2073	2026-02-16 03:35:28.615615
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
772c49ce-3bfd-419a-94df-9a56017fe811	avatars	.emptyFolderPlaceholder	\N	2026-02-17 15:40:45.855087+00	2026-02-17 15:40:45.855087+00	2026-02-17 15:40:45.855087+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-02-17T15:40:45.854Z", "contentLength": 0, "httpStatusCode": 200}	69d0b120-6b44-4ed3-a4cf-52cb3115209f	\N	{}
9cacf540-7668-487e-9c78-5d693701770f	avatars	anonym/contactPicture.png	\N	2026-02-17 15:44:53.790197+00	2026-02-17 15:44:53.790197+00	2026-02-17 15:44:53.790197+00	{"eTag": "\\"6319b3dc898c3ebf9bb79993af3f2d57-1\\"", "size": 6226, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-02-17T15:44:54.000Z", "contentLength": 6226, "httpStatusCode": 200}	dbb880ce-095a-4c81-af8a-d97353b7f921	\N	\N
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: -
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 852, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: -
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: project_members project_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_members
    ADD CONSTRAINT project_members_pkey PRIMARY KEY (id);


--
-- Name: project_members project_members_project_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_members
    ADD CONSTRAINT project_members_project_id_user_id_key UNIQUE (project_id, user_id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: task_comments task_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_comments
    ADD CONSTRAINT task_comments_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: idx_comments_task; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_comments_task ON public.task_comments USING btree (task_id);


--
-- Name: idx_tasks_creator; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tasks_creator ON public.tasks USING btree (created_by);


--
-- Name: idx_tasks_project; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tasks_project ON public.tasks USING btree (project_id);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: -
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: -
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: -
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: contacts contacts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;


--
-- Name: contacts contacts_user_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_user_id_fkey1 FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: project_members project_members_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_members
    ADD CONSTRAINT project_members_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: project_members project_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_members
    ADD CONSTRAINT project_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: projects projects_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- Name: task_comments task_comments_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_comments
    ADD CONSTRAINT task_comments_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- Name: task_comments task_comments_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_comments
    ADD CONSTRAINT task_comments_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON DELETE CASCADE;


--
-- Name: tasks tasks_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- Name: tasks tasks_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: contacts Allow all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow all" ON public.contacts USING (true) WITH CHECK (true);


--
-- Name: contacts Allow insert contacts; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow insert contacts" ON public.contacts FOR INSERT WITH CHECK (true);


--
-- Name: contacts Allow read contacts; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow read contacts" ON public.contacts FOR SELECT USING (true);


--
-- Name: tasks Anyone can insert tasks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Anyone can insert tasks" ON public.tasks FOR INSERT WITH CHECK (true);


--
-- Name: tasks Users can delete own tasks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete own tasks" ON public.tasks FOR DELETE USING ((auth.uid() = created_by));


--
-- Name: tasks Users can insert own tasks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert own tasks" ON public.tasks FOR INSERT WITH CHECK (true);


--
-- Name: tasks Users can update own tasks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update own tasks" ON public.tasks FOR UPDATE USING ((auth.uid() = created_by));


--
-- Name: tasks Users can view own tasks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view own tasks" ON public.tasks FOR SELECT USING (true);


--
-- Name: tasks Users can view tasks by auth or token; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view tasks by auth or token" ON public.tasks FOR SELECT USING (((auth.uid() = created_by) OR (guest_token IS NOT NULL)));


--
-- Name: tasks allow anonymous insert tasks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "allow anonymous insert tasks" ON public.tasks FOR INSERT TO anon WITH CHECK (true);


--
-- Name: tasks allow delete tasks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "allow delete tasks" ON public.tasks FOR DELETE TO anon USING (true);


--
-- Name: tasks allow select tasks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "allow select tasks" ON public.tasks FOR SELECT TO anon USING (true);


--
-- Name: tasks allow update tasks; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "allow update tasks" ON public.tasks FOR UPDATE TO anon USING (true) WITH CHECK (true);


--
-- Name: task_comments comments_insert_logged; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY comments_insert_logged ON public.task_comments FOR INSERT WITH CHECK ((auth.uid() IS NOT NULL));


--
-- Name: task_comments comments_select_member; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY comments_select_member ON public.task_comments FOR SELECT USING ((EXISTS ( SELECT 1
   FROM (public.tasks t
     JOIN public.projects p ON ((p.id = t.project_id)))
  WHERE ((t.id = task_comments.task_id) AND ((p.owner_id = auth.uid()) OR (EXISTS ( SELECT 1
           FROM public.project_members m
          WHERE ((m.project_id = p.id) AND (m.user_id = auth.uid())))))))));


--
-- Name: contacts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.contacts ENABLE ROW LEVEL SECURITY;

--
-- Name: contacts contacts_delete_own; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY contacts_delete_own ON public.contacts FOR DELETE USING ((user_id = auth.uid()));


--
-- Name: contacts contacts_insert_auto; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY contacts_insert_auto ON public.contacts FOR INSERT WITH CHECK ((auth.uid() IS NOT NULL));


--
-- Name: contacts contacts_manage_own; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY contacts_manage_own ON public.contacts USING ((user_id = auth.uid()));


--
-- Name: contacts contacts_select_own; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY contacts_select_own ON public.contacts FOR SELECT USING ((user_id = auth.uid()));


--
-- Name: contacts contacts_update_own; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY contacts_update_own ON public.contacts FOR UPDATE USING ((user_id = auth.uid()));


--
-- Name: profiles profile_select_own; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profile_select_own ON public.profiles FOR SELECT USING ((id = auth.uid()));


--
-- Name: profiles profile_update_own; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profile_update_own ON public.profiles FOR UPDATE USING ((id = auth.uid()));


--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: project_members; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.project_members ENABLE ROW LEVEL SECURITY;

--
-- Name: projects; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;

--
-- Name: projects projects_delete_owner; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY projects_delete_owner ON public.projects FOR DELETE USING ((owner_id = auth.uid()));


--
-- Name: projects projects_insert_auto_owner; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY projects_insert_auto_owner ON public.projects FOR INSERT WITH CHECK ((auth.uid() IS NOT NULL));


--
-- Name: projects projects_select_member; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY projects_select_member ON public.projects FOR SELECT USING (((owner_id = auth.uid()) OR (EXISTS ( SELECT 1
   FROM public.project_members m
  WHERE ((m.project_id = projects.id) AND (m.user_id = auth.uid()))))));


--
-- Name: projects projects_update_owner; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY projects_update_owner ON public.projects FOR UPDATE USING ((owner_id = auth.uid()));


--
-- Name: task_comments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.task_comments ENABLE ROW LEVEL SECURITY;

--
-- Name: tasks; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

--
-- Name: tasks tasks_delete_logged; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY tasks_delete_logged ON public.tasks FOR DELETE USING ((auth.uid() IS NOT NULL));


--
-- Name: tasks tasks_insert_logged; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY tasks_insert_logged ON public.tasks FOR INSERT WITH CHECK ((auth.uid() IS NOT NULL));


--
-- Name: tasks tasks_select_member; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY tasks_select_member ON public.tasks FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.projects p
  WHERE ((p.id = tasks.project_id) AND ((p.owner_id = auth.uid()) OR (EXISTS ( SELECT 1
           FROM public.project_members m
          WHERE ((m.project_id = p.id) AND (m.user_id = auth.uid())))))))));


--
-- Name: tasks tasks_update_logged; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY tasks_update_logged ON public.tasks FOR UPDATE USING ((auth.uid() IS NOT NULL));


--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


--
-- PostgreSQL database dump complete
--

\unrestrict oVCnw5N9dmLrux6wLfVCNX5JqTGSoRhpVETPKT97muw9mAm0dYfvBjoWQIvrFbG

