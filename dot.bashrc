
alias vcb='virsh console ocp-bootstrap'
alias vcm0='virsh console ocp-master-0'
alias vcm1='virsh console ocp-master-1'
alias vcm2='virsh console ocp-master-2'
alias vcw0='virsh console ocp-worker-0'
alias vcw1='virsh console ocp-worker-1'
alias sb='virsh start ocp-bootstrap'
alias sm='_(){ for N in {0..2}; do virsh start ocp-master-${N} ;done; }; _'
alias sw='_(){ for N in {0..1}; do virsh start ocp-worker-${N} ;done; }; _'

if true; then
alias vcb='virsh console bootstrap'
alias vcm0='virsh console master-0'
alias vcm1='virsh console master-1'
alias vcm2='virsh console master-2'
alias vcw0='virsh console worker-0'
alias vcw1='virsh console worker-1'
alias sb='virsh start bootstrap'
alias sm='_(){ for N in {0..2}; do virsh start master-${N} ;done; }; _'
alias sw='_(){ for N in {0..1}; do virsh start worker-${N} ;done; }; _'
fi

