# frozen_string_literal: true

#                   _   _           __  __            _
#         /\       | | (_)         |  \/  |          | |
#        /  \   ___| |_ ___   _____| \  / | ___   ___| | _____ _ __
#       / /\ \ / __| __| \ \ / / _ \ |\/| |/ _ \ / __| |/ / _ \ '__|
#      / ____ \ (__| |_| |\ V /  __/ |  | | (_) | (__|   <  __/ |
#     /_/    \_\___|\__|_| \_/ \___|_|  |_|\___/ \___|_|\_\___|_|
#
#     By Dustin Zeisler

require "rubygems"
require "active_mocker/version"
require "active_mocker/railtie" if defined?(Rails)
require "forwardable"
require "active_support/all"
require "active_mocker/public_methods"
require "active_mocker/config"
require "reverse_parameters"
require "active_record_schema_scrapper"
require "dissociated_introspection"
require "active_mocker/file_path_to_ruby_class"
require "active_mocker/hash_new_style"
require "active_mocker/null_progress"
require "active_mocker/progress"
require "active_mocker/parent_class"
require "active_mocker/template_creator"
require "active_mocker/mock_creator"
require "active_mocker/mock_creator/associations"
require "active_mocker/mock_creator/attributes"
require "active_mocker/mock_creator/class_methods"
require "active_mocker/mock_creator/defined_methods"
require "active_mocker/mock_creator/modules_constants"
require "active_mocker/mock_creator/recreate_class_method_calls"
require "active_mocker/mock_creator/scopes"
require "active_mocker/mock_creator/mock_build_version"
require "active_mocker/error_object"
require "active_mocker/display_errors"
require "active_mocker/generate"
require "active_mocker/attribute_types/register"
require "active_mocker/attribute_types/enum"
require "active_mocker/attribute"
require "active_mocker/late_inclusion"
