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
# https://github.com/openflighthpc/flight-env
# ==============================================================================
require 'env/command'
require 'env/environment'
require 'env/type'

module Env
  module Commands
    class Create < Command
      def run
        active_env = Environment.active
        if active_env.nil?
          Environment.global_only = true if @options.global
          type, name = args[0].split('@')
          opts = {}.tap do |h|
            h[:name] = name unless name.nil?
            h[:global] = true if @options.global
          end
          Environment.create(Type[type], **opts)
        else
          raise ActiveEnvironmentError, "unable to create with active environment: #{active_env}"
        end
      end
    end
  end
end
