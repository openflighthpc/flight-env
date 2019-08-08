# =============================================================================
# Copyright (C) 2019-present Alces Flight Ltd.
#
# This file is part of Flight Environment.
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which is available at
# <https://www.eclipse.org/legal/epl-2.0>, or alternative license
# terms made available by Alces Flight Ltd - please direct inquiries
# about licensing to licensing@alces-flight.com.
#
# Flight Environment is distributed in the hope that it will be useful, but
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR
# IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS
# OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
# PARTICULAR PURPOSE. See the Eclipse Public License 2.0 for more
# details.
#
# You should have received a copy of the Eclipse Public License 2.0
# along with Flight Environment. If not, see:
#
#  https://opensource.org/licenses/EPL-2.0
#
# For more information on Flight Environment, please visit:
# https://github.com/alces-flight/flight-env
# ==============================================================================
require 'env/command'
require 'env/environment'
require 'env/errors'
require 'env/type'

module Env
  module Commands
    class Activate < Command
      def run
        active_env = Environment.active
        unless active_env.nil?
          raise ActiveEnvironmentError, "existing active environment detected: #{active_env}"
        end
        env = Environment[args[0]]
        if ENV['flight_ENV_eval'].nil?
          if options.subshell
            puts "Activating environment #{Paint[@args.first, :cyan]}"
            shell = '/bin/bash'
            Bundler.with_clean_env do
              exec(
                {
                  'flight_ENV_subshell_env' => @args.first
                },
                [shell,'flight-env'],
                '--rcfile',
                File.join(Config.root,'etc','bashrc')
              )
            end
          else
            cmd = CLI::EVAL_CMD_GENERATOR.call("activate #{args[0]}")
            raise EvaluatorError, "directly executed activation not possible; try --subshell, or: '#{cmd}'"
          end
        end
        puts env.activator
      end
    end
  end
end
