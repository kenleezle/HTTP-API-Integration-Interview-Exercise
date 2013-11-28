require 'test/unit'
require 'test_http_server.rb'
require 'caredox_immunization_status.rb'

class CaredoxImmunizationStatusTestSuite < Test::Unit::TestCase
  def setup
    ImmunizationStatus.base_url = "http://localhost"
    TestHttpServer.run_test_servers
  end
  def test_all_systems_ok
    ImmunizationStatus.port = 11002
    istatus = ImmunizationStatus.find_by_person_id_and_state(1123123123,'NJ')
    assert_not_nil(istatus,"Received nil object, expected ImmunizationStatus")
    assert_equal(istatus.status,"current", "Received status: #{istatus.status}, expected status: current.")
    assert_equal(istatus.severity,"none", "Received severity: #{istatus.severity}, expected severity: none.")
  end
  def test_bad_person_id_input
    istatus = ImmunizationStatus.find_by_person_id_and_state('asdfasfd','NJ')
    assert_nil(istatus)
  end
  def test_bad_state_input
    istatus = ImmunizationStatus.find_by_person_id_and_state(1123123123,234234)
    assert_nil(istatus)
  end
  def test_no_connection_to_server
    ImmunizationStatus.port = 11010
    istatus = ImmunizationStatus.find_by_person_id_and_state(1123123123,'NJ')
    assert_nil(istatus)
  end
  def test_bad_status_response_from_server
    ImmunizationStatus.port = 11003
    istatus = ImmunizationStatus.find_by_person_id_and_state(1123123123,'NJ')
    assert_nil(istatus)
  end
  def test_bad_severity_response_from_server
    ImmunizationStatus.port = 11004
    istatus = ImmunizationStatus.find_by_person_id_and_state(1123123123,'NJ')
    assert_nil(istatus)
  end
  def test_error_response_code_from_server
    ImmunizationStatus.port = 11001
    istatus = ImmunizationStatus.find_by_person_id_and_state(1123123123,'NJ')
    assert_nil(istatus)
  end
  def test_empty_response_body_from_server
    ImmunizationStatus.port = 11005
    istatus = ImmunizationStatus.find_by_person_id_and_state(1123123123,'NJ')
    assert_nil(istatus)
  end
  def test_invalid_json_response_body_from_server
    ImmunizationStatus.port = 11006
    istatus = ImmunizationStatus.find_by_person_id_and_state(1123123123,'NJ')
    assert_nil(istatus)
  end
end
