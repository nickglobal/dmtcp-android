/****************************************************************************
 *   Copyright (C) 2006-2008 by Jason Ansel, Kapil Arya, and Gene Cooperman *
 *   jansel@csail.mit.edu, kapil@ccs.neu.edu, gene@ccs.neu.edu              *
 *                                                                          *
 *   This file is part of the dmtcp/src module of DMTCP (DMTCP:dmtcp/src).  *
 *                                                                          *
 *  DMTCP:dmtcp/src is free software: you can redistribute it and/or        *
 *  modify it under the terms of the GNU Lesser General Public License as   *
 *  published by the Free Software Foundation, either version 3 of the      *
 *  License, or (at your option) any later version.                         *
 *                                                                          *
 *  DMTCP:dmtcp/src is distributed in the hope that it will be useful,      *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 *  GNU Lesser General Public License for more details.                     *
 *                                                                          *
 *  You should have received a copy of the GNU Lesser General Public        *
 *  License along with DMTCP:dmtcp/src.  If not, see                        *
 *  <http://www.gnu.org/licenses/>.                                         *
 ****************************************************************************/

#ifndef DMTCPCHECKPOINTSTATE_H
#define DMTCPCHECKPOINTSTATE_H

#include "dmtcpalloc.h"
#include "kernelbufferdrainer.h"
#include "connectionmanager.h"
#include "connectionrewirer.h"
#include "../jalib/jsocket.h"
#include "../jalib/jalloc.h"

namespace dmtcp
{
  /**
  *  State of open connections, stored in checkpoint image
  */
  class ConnectionState
  {
    public:
#ifdef JALIB_ALLOCATOR
      static void* operator new(size_t nbytes, void* p) { return p; }
      static void* operator new(size_t nbytes) { JALLOC_HELPER_NEW(nbytes); }
      static void  operator delete(void* p) { JALLOC_HELPER_DELETE(p); }
#endif
      ConnectionState(const ConnectionToFds& ctfd = ConnectionToFds());

      void handleDuplicateFilesInSeparateConnections();
      void deleteDupFileConnections();
      void deleteStaleConnections();
#ifdef EXTERNAL_SOCKET_HANDLING
      void preCheckpointPeerLookup(vector<TcpConnectionInfo>& conInfoTable);
#endif
      void preLockSaveOptions();
      void preCheckpointFdLeaderElection();
      void preCheckpointDrain();
      void preCheckpointHandshakes(const UniquePid& coordinator);
      void postCheckpoint(bool isRestart);
      void outputDmtcpConnectionTable(jalib::JBinarySerializer& o);

      void postRestart();
      void doReconnect(jalib::JSocket& coordinator,
                       jalib::JSocket& restoreListen);

    private:
      KernelBufferDrainer _drain;
      ConnectionToFds     _conToFds;
      ConnectionRewirer   _rewirer;
  };
}

#endif
