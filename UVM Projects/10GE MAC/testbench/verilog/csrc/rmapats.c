// file = 0; split type = patterns; threshold = 100000; total count = 0.
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "rmapats.h"

scalar dummyScalar;
scalar fScalarIsForced=0;
scalar fScalarIsReleased=0;
scalar fScalarHasChanged=0;
scalar fForceFromNonRoot=0;
scalar fNettypeIsForced=0;
scalar fNettypeIsReleased=0;
void  hsG_0 (struct dummyq_struct * I1097, EBLK  * I1098, U  I651);
void  hsG_0 (struct dummyq_struct * I1097, EBLK  * I1098, U  I651)
{
    U  I1341;
    U  I1342;
    U  I1343;
    struct futq * I1344;
    I1341 = ((U )vcs_clocks) + I651;
    I1343 = I1341 & ((1 << fHashTableSize) - 1);
    I1098->I697 = (EBLK  *)(-1);
    I1098->I701 = I1341;
    if (I1341 < (U )vcs_clocks) {
        I1342 = ((U  *)&vcs_clocks)[1];
        sched_millenium(I1097, I1098, I1342 + 1, I1341);
    }
    else if ((peblkFutQ1Head != ((void *)0)) && (I651 == 1)) {
        I1098->I702 = (struct eblk *)peblkFutQ1Tail;
        peblkFutQ1Tail->I697 = I1098;
        peblkFutQ1Tail = I1098;
    }
    else if ((I1344 = I1097->I1057[I1343].I714)) {
        I1098->I702 = (struct eblk *)I1344->I713;
        I1344->I713->I697 = (RP )I1098;
        I1344->I713 = (RmaEblk  *)I1098;
    }
    else {
        sched_hsopt(I1097, I1098, I1341);
    }
}
#ifdef __cplusplus
extern "C" {
#endif
void SinitHsimPats(void);
#ifdef __cplusplus
}
#endif
