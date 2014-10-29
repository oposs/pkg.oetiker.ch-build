/*
 * CDDL HEADER START
 *
 * The contents of this file are subject to the terms of the
 * Common Development and Distribution License, Version 1.0 only
 * (the "License").  You may not use this file except in compliance
 * with the License.
 *
 * You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
 * or http://www.opensolaris.org/os/licensing.
 * See the License for the specific language governing permissions
 * and limitations under the License.
 *
 * When distributing Covered Code, include this CDDL HEADER in each
 * file and include the License file at usr/src/OPENSOLARIS.LICENSE.
 * If applicable, add the following below this CDDL HEADER, with the
 * fields enclosed by brackets "[]" replaced with your own identifying
 * information: Portions Copyright [yyyy] [name of copyright owner]
 *
 * CDDL HEADER END
 */
/*
 * Copyright 2011 Nexenta Systems, Inc.  All rights reserved.
 * Use is subject to license terms.
*/

#ifndef _ENDIAN_H
#define _ENDIAN_H

#define __LITTLE_ENDIAN 1234
#define __BIG_ENDIAN    4321

#if defined(__i386__) || defined(__x86_64__)
#define __BYTE_ORDER    __LITTLE_ENDIAN
#elif defined(__sparc__)
#define __BYTE_ORDER    __BIG_ENDIAN
#endif

#define LITTLE_ENDIAN   __LITTLE_ENDIAN
#define BIG_ENDIAN      __BIG_ENDIAN
#define BYTE_ORDER      __BYTE_ORDER

#endif	/* _ENDIAN_H */
