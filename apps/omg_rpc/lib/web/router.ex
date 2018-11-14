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

defmodule OMG.RPC.Web.Router do
  use OMG.RPC.Web, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api/swagger" do
    forward("/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :omg_rpc, swagger_file: "swagger.json")
  end

  scope "/", OMG.RPC.Web do
    pipe_through(:api)

    post("/block.get", Controller.Block, :get_block)
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "OMG API"
      }
    }
  end
end
