import React from "react";

export function Transfer({ transferTokens }) {
  return (
    <div>
      <h4></h4>
      <form
        onSubmit={(event) => {
          // This function just calls the transferTokens callback with the
          // form's data.
          event.preventDefault();

          const formData = new FormData(event.target);
          const to = formData.get("to");
          const amount = formData.get("amount");
          const text = formData.get("text"); 
          if (to && amount) {
            transferTokens(to, amount);
          }
        }}
      >
        <div className="form-group">
          <label>Amount of ethers you donate</label>
          <input
            className="form-control"
            type="string"          
            name="amount"
            placeholder="0.001"
            required
          />
        </div>
        <div className="form-group">
          <label>URL(ex, ens.domains)</label>
          <input className="form-control" type="text" name="to" required />
        </div>
        <div className="form-group">
          <label>message(send via push protocol)</label>
          <input className="form-control" type="text" name="message"  />
        </div>
        <div className="form-group">
          <input className="btn btn-primary" type="submit" value="Donate" />
        </div>
      </form>
    </div>
  );
}
