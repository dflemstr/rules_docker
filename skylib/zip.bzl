# Copyright 2017 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""Functions for producing the gzip of an artifact."""

def gzip(ctx, artifact):
    """Create an action to compute the gzipped artifact."""
    out = ctx.new_file(artifact.basename + ".gz")
    ctx.action(
        command = "%s -n < %s > %s" % (ctx.executable.gzip.path, artifact.path, out.path),
        inputs = [artifact, ctx.executable.gzip],
        outputs = [out],
        use_default_shell_env = True,
        mnemonic = "GZIP",
    )
    return out

def gunzip(ctx, artifact):
    """Create an action to compute the gunzipped artifact."""
    out = ctx.new_file(artifact.basename + ".nogz")
    ctx.action(
        command = "%s -d < %s > %s" % (ctx.executable.gzip.path, artifact.path, out.path),
        inputs = [artifact, ctx.executable.gzip],
        outputs = [out],
        use_default_shell_env = True,
        mnemonic = "GUNZIP",
    )
    return out

tools = {
    "gzip": attr.label(
        allow_files = True,
        cfg = "host",
        default = Label("@gzip//:gzip"),
        executable = True,
    ),
}
