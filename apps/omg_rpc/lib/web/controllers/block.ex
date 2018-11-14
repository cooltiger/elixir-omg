# Copyright 2018 OmiseGO Pte Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

defmodule OMG.RPC.Web.Controller.Block do
  # TODO: @moduledoc false

  use OMG.RPC.Web, :controller
  use PhoenixSwagger

  action_fallback(OMG.RPC.Web.Controller.Fallback)

  def get_block(conn, params) do
    with {blknum, ""} <- Map.get(params, "blknum") |> Integer.parse() do
      json(conn, %{
        version: "1",
        success: true,
        data: %{
          blknum: blknum
        }
      })
    end
  end
end
