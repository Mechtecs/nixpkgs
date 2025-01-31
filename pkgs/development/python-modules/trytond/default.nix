{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, defusedxml
, lxml
, relatorio
, genshi
, python-dateutil
, polib
, python-sql
, werkzeug
, wrapt
, passlib
, pydot
, python-Levenshtein
, html2text
, weasyprint
, gevent
, pillow
, withPostgresql ? true
, psycopg2
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "trytond";
  version = "6.4.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-eTYm3anMKhgoaB8t5jald5XRD3PIVijJP4vmh0pA9lE=";
  };

  propagatedBuildInputs = [
    defusedxml
    lxml
    relatorio
    genshi
    python-dateutil
    polib
    python-sql
    werkzeug
    wrapt
    passlib

    # extra dependencies
    pydot
    python-Levenshtein
    html2text
    weasyprint
    gevent
    pillow
  ] ++ relatorio.optional-dependencies.fodt
  ++ passlib.optional-dependencies.bcrypt
  ++ passlib.optional-dependencies.argon2
  ++ lib.optional withPostgresql psycopg2;

  checkInputs = [ unittestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export TRYTOND_DATABASE_URI="sqlite://"
    export DB_NAME=":memory:";
  '';

  unittestFlagsArray = [ "-s" "trytond.tests" ];

  meta = with lib; {
    description = "The server of the Tryton application platform";
    longDescription = ''
      The server for Tryton, a three-tier high-level general purpose
      application platform under the license GPL-3 written in Python and using
      PostgreSQL as database engine.

      It is the core base of a complete business solution providing
      modularity, scalability and security.
    '';
    homepage = "http://www.tryton.org/";
    changelog = "https://hg.tryton.org/trytond/file/${version}/CHANGELOG";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ udono johbo ];
  };
}
